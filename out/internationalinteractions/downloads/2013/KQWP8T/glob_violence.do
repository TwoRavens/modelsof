/*Testing the effects of globalization on Civil War Onset__Ranveig Flaten & Indra de Soysa. II 2012*/

use gini_final , replace

la var cow "Correlates of war number code"
la var incidencev410 "Incidence of civil war from UCDP data"
la var onset2cv410 "onset of civil war after 2 year hiatus"
la var onset5cv410 "onset of civil war after 5 year hiatus"
la var physint "respect for physical integrity rights from CIRI data"
la var wbccode "World bank country codes alphabetic"
la var country "Country"
la var ecg "Economic Globalization"
la var socg "Social-cultural Globalization"
la var polg "Political Globalization"
la var glob "Total Globalization"
la var cgvdemoc "Democracy dummy according to Cheibub Ghandhi & Vreeland"
la var lnpop "log of total population"
la var lngdppc "log of per capita income"
la var lngovt "log of government consumption a share of GDP"
la var dem "Democracy = 1 if greater than 6 on polity scale and 0 if not"
la var aut "autocracy = 1 if smaller than -6 on polity scale and 0 if not"
la var iethfrac "ethfrac extrapolated beyond 1999"
la var iethfrac2 "the square of iethfrac"
la var britishlegal "country has British legal system"
la var socialistlegal " country has socialist legal tradition"
la var coldwar "dummy for cold war years with post cold war begining in 1991"
la var western "Western countries including Japan following Fearon and Laitin«s coding"
la var coldwarxglob "Interaction term between coldwar years and globalization"
la var westxglob "interaction term between western countries and globalization"


/*testing the effects of globalization on conflict onset==complete model___TABLE1*/

logit onset2cv410 l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if year>1970 & glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel replace

logit onset2cv410 l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel 

logit onset2cv410 l.ecg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel 

logit onset2cv410 l.socg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel 

logit onset2cv410 l.polg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel 


/*testing onset after a 5 year hiatus____TABLE1*/
logit onset5cv410 l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel 

logit onset5cv410 l.ecg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel 

logit onset5cv410 l.socg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel 

logit onset5cv410 l.polg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 if glob!=., cl(cow)
outreg2 using table1.xls, bdec(2)  sym(***,**,*) onecol nolabel 


/*Robustness tests with interactions for cold war and post cold war eras*/

logit onset2cv410 L.onset2cv410 l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year coldwar coldwarxglob, cl(cow)
logit onset5cv410 L.onset5cv410 l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year coldwar coldwarxglob,  cl(cow)

logit onset2cv410 L.onset2cv410 l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year western westxglob, cl(cow)
logit onset5cv410 L.onset5cv410 l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year western westxglob,  cl(cow)

/* Testing robustness with govt in the model*/

logit onset2cv410  l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 lngovt, cl(cow)


/*robustness with legal systems & without per cap income*/
logit onset2cv410  l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 socialistlegal britishlegal, cl(cow)
logit onset2cv410  l.glob  l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2 i.year peaceyrs _spline1 _spline2 _spline3 socialistlegal britishlegal, cl(cow)


/*testing for multicollinearity*/

reg onset5cv410 l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac l.iethfrac2  peaceyrs _spline1 _spline2 _spline3, cl(cow)
vif 

/*Testing the effects of globalization on human rights_____TABLE2*/

newey physint l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac incidencev410 socialistlegal britishlegal i.year, force lag(1)
outreg2 using table2.xls, bdec(2)  sym(***,**,*) onecol nolabel replace
sum physint glob lngdppc if e(sample)

newey physint l.ecg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac incidencev410 socialistlegal britishlegal i.year, force lag(1)
outreg2 using table2.xls, bdec(2)  sym(***,**,*) onecol nolabel

newey physint l.socg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac incidencev410 socialistlegal britishlegal i.year, force lag(1)
outreg2 using table2.xls, bdec(2)  sym(***,**,*) onecol nolabel 

newey physint l.polg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac incidencev410 socialistlegal britishlegal i.year, force lag(1)
outreg2 using table2.xls, bdec(2)  sym(***,**,*) onecol nolabel 

oprobit physint l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac incidencev410 socialistlegal britishlegal i.year, cl(cow)

oprobit physint l.ecg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac incidencev410 socialistlegal britishlegal i.year, cl(cow)
oprobit physint l.socg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac incidencev410 socialistlegal britishlegal i.year, cl(cow)
oprobit physint l.polg l.lngdppc l.lnpop l.fl_oil l.dem l.aut l.iethfrac incidencev410 socialistlegal britishlegal i.year, cl(cow)

/*testing with country fixed effects_____TABLE2*/

newey physint l.glob l.lngdppc l.lnpop l.fl_oil l.dem l.aut incidencev410 socialistlegal britishlegal i.year i.cow, force lag(1)
outreg2 using table2.xls, bdec(2)  sym(***,**,*) onecol nolabel 
newey physint l.ecg l.lngdppc l.lnpop l.fl_oil l.dem l.aut incidencev410 socialistlegal britishlegal i.year i.cow, force lag(1)
outreg2 using table2.xls, bdec(2)  sym(***,**,*) onecol nolabel 
newey physint l.socg l.lngdppc l.lnpop l.fl_oil l.dem l.aut incidencev410 socialistlegal britishlegal i.year i.cow, force lag(1)
outreg2 using table2.xls, bdec(2)  sym(***,**,*) onecol nolabel 
newey physint l.polg l.lngdppc l.lnpop l.fl_oil l.dem l.aut incidencev410 socialistlegal britishlegal i.year i.cow, force lag(1)
outreg2 using table2.xls, bdec(2)  sym(***,**,*) onecol nolabel


/*Multiple Imputation using regress of ECG to increase country coverage*/
mi set mlong
mi stset, clear
mi register imputed (ecg)
mi register regular (incidencev410 fl_oil lngdppc lnpop dem aut iethfrac iethfrac2 peaceyrs _spline1 _spline2 _spline3)
mi impute pmm ecg  = incidencev410 fl_oil lngdppc lnpop dem aut iethfrac iethfrac2 peaceyrs _spline1 _spline2 _spline3, add(5) force replace
mi estimate: logit onset5cv410 ecg lngdppc lnpop peaceyrs _spline1 _spline2 _spline3, cl(cow)
mi estimate: logit onset5cv410 ecg lngdppc lnpop fl_oil iethfrac iethfrac2 dem aut peaceyrs _spline1 _spline2 _spline3, cl(cow)

exit
