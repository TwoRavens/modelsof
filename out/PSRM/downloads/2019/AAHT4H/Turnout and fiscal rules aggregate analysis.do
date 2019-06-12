

use "World with parliamentary elections.dta"

*Generation of countrynumerical* 
encode country, gen (ncountry)
xtset ncountry year

*Generation of log of GDP per capita*
generate loggdpcap= log(gdppercapitaconstant2005uswb)

*Generation of log of district magnitude* 
generate logdistricmag= log( mdmh)


*Generation of compulsory voting dummy*
encode  comp, generate (ncomp)
generate compulsoryvoting=0
replace compulsoryvoting=1 if ncomp==2
replace compulsoryvoting=. if ncomp==.



*Generation of log of population*
generate logpop= log( pop)


*Generation of number of parties*

*Existence of 2. government party*
generate egovparty2=0
replace egovparty2=1 if gov2seat !=.

*Existence of 3. government party*
generate egovparty3=0
replace egovparty3=1 if gov3seat !=.


*Existence of 1. opposition party*
generate eoppparty1=0
replace eoppparty1=1 if opp1seat !=.

*Existence of 2. opposition party*
generate eoppparty2=0
replace eoppparty2=1 if opp2seat !=.

*Existence of 1. opposition party*
generate eoppparty3=0
replace eoppparty3=1 if opp3seat !=.



*Total number of parties (treats independent legislators as parties)*
generate totalnumberofparties= 1+egovparty2 + egovparty3 + eoppparty1 + eoppparty2 + eoppparty3 + govoth + oppoth + ulprty



*Generation of chiefexecutiveelection dummy*
generate chiefexecutiveelection=0
replace chiefexecutiveelection=1 if presidentialsystem==0 & legelec==1
replace chiefexecutiveelection=1 if presidentialsystem==1 & exelec==1
replace chiefexecutiveelection=. if legelec==. | exelec==. 

*Generation of dummy for expenditure rule with statuary or constitutional basis*
generate statconER=0
replace statconER=1 if er== 1 & legal_n_er==3 |er== 1 & legal_n_er==5
replace statconER=. if er==.

*Generation of dummy for revenue rule with statuary or constitutional basis*
generate statconRR=0
replace statconRR=1 if rr== 1 & legal_n_rr==3 |rr== 1 & legal_n_rr==5
replace statconRR=. if rr==.

*Generation of dummy for balanced budget rule with statuary or constitutional basis*
generate statconBBR=0
replace statconBBR=1 if bbr== 1 & legal_n_bbr==3 |bbr== 1 & legal_n_bbr==5
replace statconBBR=. if bbr==.



*Generation of dummy for debt rule with statuary or constitutional basis*
generate statconDR=0
replace statconDR=1 if dr== 1 & legal_n_dr==3 |dr== 1 & legal_n_dr==5
replace statconDR=. if dr==.



*Generation of reform expenditure rule*
generate reformER=0
replace reformER=1 if statconER==1 & l1.statconER==0
replace reformER=. if statconER==.

*Generation of reform revenue rule*
generate reformRR=0
replace reformRR=1 if statconRR==1 & l1.statconRR==0
replace reformRR=. if statconRR==.

*Generation of reform balance budget rule*
generate reformBBR=0
replace reformBBR=1 if statconBBR==1 & l1.statconBBR==0
replace reformBBR=. if statconBBR==.

*Generation of reform debt rule*
generate reformDR=0
replace reformDR=1 if statconDR==1 & l1.statconDR==0
replace reformDR=. if statconDR==.


*Generation of non-expenditure rule years. Some countries with problems*
generate nonERyears=.
replace nonERyears= year-1984 if statconER==0
replace nonERyears= 0 if statconER==1
replace nonERyears= year-1984 if statconER==1 & l.statconER==0





*Generation of IMF national expenditure rules index* 
*Rescale cover of expenditure rule*
generate cover_n_er2= cover_n_er/2

*Rescale legal scope of expenditure rule*
generate legal_n_er2= legal_n_er/5

*generation of Expenditure rules strenght index* 
generate ER_n_strengh = cover_n_er2 + legal_n_er2 + enforce_n_er + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n


*Rescale cover of revenue rule*
generate cover_n_rr2= cover_n_rr/2

*Rescale legal scope of revenue rule*
generate legal_n_rr2= legal_n_rr/5

*generation of revenue rules strenght index*
generate RR_n_strengh= cover_n_rr2 + legal_n_rr2 + enforce_n_rr + frl + suport_budg_n + suport_impl_n

*Rescale cover of balanced budget rule*
generate cover_n_bbr2=cover_n_bbr/2

*Rescale legal scope of balanced budget rule*
generate legal_n_bbr2= legal_n_bbr/5

*generation of balanced budget rules strenght index*
generate BBR_n_strengh= cover_n_bbr2 + legal_n_bbr2 + enforce_n_bbr + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n

*Rescale cover of debt rule*
generate cover_n_dr2= cover_n_dr/2

*Rescale legal scope of debt rule*
generate legal_n_dr2= legal_n_dr/5

*generation of debt rule strenght index*
generate DR_n_strengh= cover_n_dr2 + legal_n_dr2 + enforce_n_dr + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n


*Generation of overal fiscal rules index*
generate nationalfiscalrulesindex=((DR_n_strengh*5/7) + (BBR_n_strengh*5/7) + (RR_n_strengh*5/6) + (ER_n_strengh*5/7))/4


*Generation of majority government dummy*
generate majoritygov=0
replace majoritygov=1 if maj>0.5
replace majoritygov=. if maj==.

*Generation of singlepartygovernment dummy*
generate singlepartygov=0
replace singlepartygov= 1 if herfgov==1
replace singlepartygov=. if herfgov==.

*generation of "strong government" dummy*
generate stronggov=0
replace stronggov= 1 if singlepartygov==1 & majoritygov==1
replace stronggov=. if singlepartygov==. | majoritygov==. 

*Generation of national fiscal rules in place*
generate nationaler=0
replace nationaler=1 if er==1 & er_supra!=2
replace nationaler=. if er==. 

generate nationalrr=0
replace nationalrr=1 if rr==1 & rr_supra!=2
replace nationalrr=. if rr==. 

generate nationalbbr=0
replace nationalbbr=1 if bbr==1 & bbr_supra!=2
replace nationalbbr=. if bbr==. 

generate nationaldr=0
replace nationaldr=1 if dr==1 & dr_supra!=2
replace nationaldr=. if dr==. 


generate nationalfiscalrule=0
replace nationalfiscalrule=1 if nationaler==1 | nationalrr==1 | nationalbbr==1 | nationaldr==1
replace nationalfiscalrule=. if year<1985




*Figure1 : with types of fiscal rules*
bysort year : egen year_meanfiscalrules = mean(nationalfiscalrule)
bysort year : egen year_meanerule = mean(nationaler)
bysort year : egen year_meanrrrule = mean(nationalrr)
bysort year : egen year_meanbbrule = mean(nationalbbr)
bysort year : egen year_meandrule = mean(nationaldr)

twoway (line year_meanbbrule year, lpattern(solid) lcolor(black))(line year_meanerule year,lpattern(shortdash)  lcolor(black) ) (line year_meandrule year, lpattern(longdash)  lcolor(black)) (line year_meanrrrule year, lpattern("..-..")  lcolor(black)),graphregion(color(white))legend (label(1 "Balanced budget rule") label(2 "Expenditure rule") label(3 "Debt rule") label(4 "Revenue rule"))  ytitle(Share of countries with national fiscal rules) ylabel(, format(%9.1f)) ylabel( 0.0 0.1 0.2 0.3) xlabel(1985 1990 1995 2000 2005 2010 2014), if year >= 1985
graph export figure1.tif



*Med Voting age population (vapvt) turnout*



* Table 1: Test with rules dummies only non-autocracies* 
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconRR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop statconBBR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop  statconDR i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if polity2>5
test statconER= statconRR =statconBBR= statconDR 







*Appendix A: Descriptive statistics 
* Descriptive statistics only non-autocracies*
xtsum vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR ER_n_strengh RR_n_strengh BBR_n_strengh DR_n_strengh nationalfiscalrulesindex  if vapvt!=. & loggdpcap!=. & pr!=. & gggrossdebtpctgdpimf!=. & compulsoryvoting!=. &  logpop!=. & statconER!=. & statconRR!=. & statconBBR!=. & statconDR!=. & ER_n_strengh!=. & RR_n_strengh!=. & BBR_n_strengh!=. & DR_n_strengh!=. & nationalfiscalrulesindex!=. & polity2>5


*Descriptive statistics OECD* 
xtsum vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR ER_n_strengh RR_n_strengh BBR_n_strengh DR_n_strengh nationalfiscalrulesindex  if vapvt!=. & loggdpcap!=. & pr!=. & gggrossdebtpctgdpimf!=. & compulsoryvoting!=. &  logpop!=. & statconER!=. & statconRR!=. & statconBBR!=. & statconDR!=. & ER_n_strengh!=. & RR_n_strengh!=. & BBR_n_strengh!=. & DR_n_strengh!=. & nationalfiscalrulesindex!=.  &  oecd==1


*Appendix B: Results without controls*
xtreg vapvt  statconER  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt statconRR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt  statconBBR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt  statconDR i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt   statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if polity2>5
test statconER= statconRR =statconBBR= statconDR 


xtreg vapvt   ER_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt  RR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt  BBR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt  DR_n_strengh i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt  nationalfiscalrulesindex i.year, fe cluster ( ncountry), if polity2>5

xtreg vapvt  statconER  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt  statconRR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt  statconBBR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt  statconDR i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt  statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if oecd==1
test statconER= statconRR =statconBBR= statconDR 



xtreg vapvt ER_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt RR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt  BBR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt  DR_n_strengh i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt nationalfiscalrulesindex i.year, fe cluster ( ncountry), if oecd==1



* Appendix C and figure 2: plotting before and after fiscal rules*
generate statconrule= 0
replace statconrule=1 if statconER==1 | statconRR==1| statconBBR==1 | statconDR==1
replace statconrule=. if statconER==. & statconRR==. & statconBBR==. & statconDR==.

generate shift=0
sort ncountry year
replace shift=1 if statconrule==1 & l.statconrule==0
replace shift=. if statconrule==. 

generate distancerule=0
replace distancerule=4 if shift==1 
replace distancerule=1 if f3.shift==1
replace distancerule= 2 if f2.shift==1 
replace distancerule= 3 if f.shift==1
replace distancerule=5 if l.shift==1
replace distancerule=6 if l2.shift==1
replace distancerule=7 if l3.shift==1
replace distancerule=. if shift==. 

*Figure 2: Only democracies*
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop  i.distancerule  i.year, fe cluster ( ncountry), if polity2>5
margins distancerule
marginsplot,  level(90) ytitle(Predicted turnout) xtitle(Years from introduction of fiscal rule)  xlabel(0 "All other years" 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "+1" 6 "+2" 7 "+3") legend (off)   scheme(s1mono) plot1opts(lpattern(dot)) 
graph export figure2.tif

*Only OECD*
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop  i.distancerule  i.year, fe cluster ( ncountry), if oecd==1
margins distancerule
marginsplot,  level(90) ytitle(Predicted turnout) xtitle(Years from introduction of fiscal rule)  xlabel(0 "All other years" 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "+1" 6 "+2" 7 "+3") legend (off)   scheme(s1mono) plot1opts(lpattern(dot)) 



*Appendix D:  Strenght of fiscal rules. 
*Table D1: Test with strenght of rules only non-autocracies* 
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop  ER_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop RR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop BBR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop DR_n_strengh i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop nationalfiscalrulesindex i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop nationalfiscalrulesindex i.year, fe cluster ( ncountry) level (90), if polity2>5

* Table D2: International socures. All non-autocracies* 
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu ER_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu RR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu BBR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu DR_n_strengh i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu  nationalfiscalrulesindex i.year, fe cluster ( ncountry), if polity2>5


*Addtional analysis: International sources for fiscal rules dummies* 
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconER  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu  statconRR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconBBR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconDR i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if polity2>5
test statconER= statconRR =statconBBR= statconDR 


* Appendix E: OECD analysis: 

* Table E1: Test with rules dummies only OECD* 
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconER  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconRR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop statconBBR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconDR i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if oecd==1
test statconER= statconRR =statconBBR= statconDR 


* Table E2: Test with strenght of rules only OECD* 
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop ER_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop RR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop BBR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop DR_n_strengh i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop nationalfiscalrulesindex i.year, fe cluster ( ncountry), if oecd==1



* Table E3: International sources: Only OECD* 

xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu ER_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu RR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu BBR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu DR_n_strengh i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu nationalfiscalrulesindex i.year, fe cluster ( ncountry), if oecd==1



* Additional analysis: International sources: Test with rules dummies only OECD* 
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconER  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconRR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt  loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconBBR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt  loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconDR i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if oecd==1



* Foot note: Country-specific time trends included* 
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER c.year#i.ncountry i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconRR  c.year#i.ncountry i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop statconBBR c.year#i.ncountry i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop  statconDR c.year#i.ncountry i.year, fe cluster ( ncountry), if polity2>5
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR c.year#i.ncountry i.year, fe cluster ( ncountry), if polity2>5


xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconER c.year#i.ncountry i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconRR  c.year#i.ncountry i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop statconBBR c.year#i.ncountry i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconDR  c.year#i.ncountry i.year, fe cluster ( ncountry), if oecd==1
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR c.year#i.ncountry i.year, fe cluster ( ncountry), if oecd==1



*Foot note: Countries with and without expenditure rules*
xtsum  statconER   if polity2>5 & year==2014 
xtsum  statconER   if year==2014  &  oecd==1
xtsum  statconER   if polity2>5 & year==2014 & oecd!=1

*Excluding Italy*
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if polity2>5 & countrycode!=80 



*________________________________________________________________________*


*Description of turnout*
* Trend in turnout*
bysort year : egen year_meanturnout1 = mean(vapvt)
twoway (line year_meanturnout1 year, lcolor(gs10)) (lfit year_meanturnout year, lcolor(black)) ,graphregion(color(white))legend (off) ytitle(Average electoral turnout) ylabel(, format(%9.1f)) xlabel(1985 1990 1995 2000 2005 2010 2014), if year >= 1985 & polity2>5 & year<2015




* Development of turnout*
bysort year : egen year_meanturnout = mean(vapvt)
twoway (line year_meanturnout year) ,graphregion(color(white))legend (off) ytitle(Average turnout in democracies) ylabel(, format(%9.1f)) xlabel(1985 1990 1995 2000 2005 2010 2014), if year >= 1985 &polity2>5

twoway (lfit year_meanturnout year),graphregion(color(white))legend (off) ytitle(Fitted average turnout in democracies) ylabel(, format(%9.1f)) xlabel(1985 1990 1995 2000 2005 2010 2014), if year >= 1985 & polity2>5

*____________________________________________________________* 
* Various other samples* 


*Excluding presidential systems*
 
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconER  i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu  statconRR  i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconBBR  i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconDR i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0



xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu ER_n_strengh  i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu RR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu BBR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu DR_n_strengh i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0
xtreg vapvt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu  nationalfiscalrulesindex i.year, fe cluster ( ncountry), if polity2>5 & presidentialsystem==0


xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconER  i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconRR  i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0
xtreg vapvt  loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconBBR  i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0
xtreg vapvt  loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconDR i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0

 
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu ER_n_strengh  i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0
xtreg vapvt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu RR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu BBR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu DR_n_strengh i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0
xtreg vapvt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu nationalfiscalrulesindex i.year, fe cluster ( ncountry), if oecd==1 & presidentialsystem==0

*No sample restrictions* 


* Test with rules dummies all countries* 
xtreg vapvt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop statconER  i.year, fe cluster ( ncountry)
xtreg vapvt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop statconRR  i.year, fe cluster ( ncountry)
xtreg vapvt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop statconBBR  i.year, fe cluster ( ncountry)
xtreg vapvt loggdpcap pr polity2 gggrossdebtpctgdpimf  compulsoryvoting logpop statconDR i.year, fe cluster ( ncountry)
xtreg vapvt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry)


*Test with strenght of rules all countries* 
xtreg vapvt loggdpcap pr polity2 gggrossdebtpctgdpimf  compulsoryvoting logpop ER_n_strengh  i.year, fe cluster ( ncountry)
xtreg vapvt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop RR_n_strengh  i.year, fe cluster ( ncountry)
xtreg vapvt loggdpcap pr  polity2 gggrossdebtpctgdpimf compulsoryvoting logpop BBR_n_strengh  i.year, fe cluster ( ncountry)
xtreg vapvt loggdpcap pr  polity2 gggrossdebtpctgdpimf compulsoryvoting logpop DR_n_strengh i.year, fe cluster ( ncountry)
xtreg vapvt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop nationalfiscalrulesindex i.year, fe cluster ( ncountry)



*Vote turnout as pct. of registred voters*

*Descriptive statistics only non-autocracies*
xtsum vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR ER_n_strengh RR_n_strengh BBR_n_strengh DR_n_strengh nationalfiscalrulesindex  if vt!=. & loggdpcap!=. & pr!=. & gggrossdebtpctgdpimf!=. & compulsoryvoting!=. &  logpop!=. & statconER!=. & statconRR!=. & statconBBR!=. & statconDR!=. & ER_n_strengh!=. & RR_n_strengh!=. & BBR_n_strengh!=. & DR_n_strengh!=. & nationalfiscalrulesindex!=. & polity2>5


*Descriptive statistics OECD* 
xtsum vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR ER_n_strengh RR_n_strengh BBR_n_strengh DR_n_strengh nationalfiscalrulesindex  if vt!=. & loggdpcap!=. & pr!=. & gggrossdebtpctgdpimf!=. & compulsoryvoting!=. &  logpop!=. & statconER!=. & statconRR!=. & statconBBR!=. & statconDR!=. & ER_n_strengh!=. & RR_n_strengh!=. & BBR_n_strengh!=. & DR_n_strengh!=. & nationalfiscalrulesindex!=.  &  oecd==1


* Test with rules dummies only non-autocracies* 
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconRR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop statconBBR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop  statconDR i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if polity2>5


*Test with strenght of rules only non-autocracies* 
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop  ER_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop RR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop BBR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop DR_n_strengh i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop nationalfiscalrulesindex i.year, fe cluster ( ncountry), if polity2>5


* Test with rules dummies all countries* 
xtreg vt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop statconER  i.year, fe cluster ( ncountry)
xtreg vt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop statconRR  i.year, fe cluster ( ncountry)
xtreg vt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop statconBBR  i.year, fe cluster ( ncountry)
xtreg vt loggdpcap pr polity2 gggrossdebtpctgdpimf  compulsoryvoting logpop statconDR i.year, fe cluster ( ncountry)
xtreg vt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry)


*Test with strenght of rules all countries* 
xtreg vt loggdpcap pr polity2 gggrossdebtpctgdpimf  compulsoryvoting logpop ER_n_strengh  i.year, fe cluster ( ncountry)
xtreg vt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop RR_n_strengh  i.year, fe cluster ( ncountry)
xtreg vt loggdpcap pr  polity2 gggrossdebtpctgdpimf compulsoryvoting logpop BBR_n_strengh  i.year, fe cluster ( ncountry)
xtreg vt loggdpcap pr  polity2 gggrossdebtpctgdpimf compulsoryvoting logpop DR_n_strengh i.year, fe cluster ( ncountry)
xtreg vt loggdpcap pr polity2 gggrossdebtpctgdpimf compulsoryvoting logpop nationalfiscalrulesindex i.year, fe cluster ( ncountry)



* Test with rules dummies only OECD* 
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconER  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconRR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop statconBBR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconDR i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if oecd==1


*Test with strenght of rules only OECD* 
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop ER_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop RR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop BBR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop DR_n_strengh i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop nationalfiscalrulesindex i.year, fe cluster ( ncountry), if oecd==1




*Robustness test, internatinal sources (IMF and currency unions)*

*All non-autocracies* 
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconER  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu  statconRR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconBBR  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconDR i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if polity2>5



xtreg vt loggdpcap pr gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu ER_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu RR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu BBR_n_strengh  i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu DR_n_strengh i.year, fe cluster ( ncountry), if polity2>5
xtreg vt loggdpcap pr gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu  nationalfiscalrulesindex i.year, fe cluster ( ncountry), if polity2>5


* Test with rules dummies only OECD* 
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconER  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconRR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconBBR  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop underimfprogramme cu statconDR i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu statconER statconRR statconBBR statconDR i.year, fe cluster ( ncountry), if oecd==1


*Test with strenght of rules only OECD* 
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu ER_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr  gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu RR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu BBR_n_strengh  i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr   gggrossdebtpctgdpimf  compulsoryvoting logpop underimfprogramme cu DR_n_strengh i.year, fe cluster ( ncountry), if oecd==1
xtreg vt loggdpcap pr   gggrossdebtpctgdpimf compulsoryvoting logpop  underimfprogramme cu nationalfiscalrulesindex i.year, fe cluster ( ncountry), if oecd==1
