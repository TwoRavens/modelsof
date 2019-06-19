/************************************************************************************************************************************
Conti and Pudney
Survey Design and the Analysis of Satisfaction
Review of Economics and Statistics, 2011
************************************************************************************************************************************/

clear
clear mata
set mem 400m
set more off
set matsize 800
cap log close
log using "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.log", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\aindresp"
renpfix a
g datayear=1991
*NB fieldwork starts September 1991 for wave 1 & finishes by december*
g doiy4=1991
g wave=1
keep hid pid datayear wave doiy4 doim doid ivfio doby sex qfachi qfedhi paynu jbhrs jbotpd jbsect oprlg1 nchild fihhmn region ///
    jbstat jbft age12 paju pasoc maju masoc pargsc margsc plbornc jbterm mlstat hlstat hhsize tenure paygu ///
    jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 jbsat jssat1 jssat2 jssat3 jssat4 jssat5 jssat jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived race ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbasp1 jbasp2 jbsic tuin1 jbonus jbopps jbmngr j2has age ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk1", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ajobhist"
renpfix a
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk1"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk1", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ahhsamp"
renpfix a
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk1"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk1", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\bindresp"
renpfix b
g datayear=1992
g wave=2
keep hid pid datayear wave doiy4 doim doid ivfio doby sex qfachi qfedhi paynu jbhrs jbotpd jbsect mlstat nchild fihhmn tenure region ///
    jbstat jbft age12 plbornc jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 jbsat jbterm jssat1 jssat2 jssat3 jssat4 jssat5 jssat jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic tuin1 jbonus jbopps jbmngr j2has age howlng cjsten jbttwt jbpen sppayg spjbhr spjbot ///
    jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk2", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\bjobhist"
renpfix b
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk2"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk2", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\bhhsamp"
renpfix b
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk2"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk2", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\cindresp"
renpfix c
g datayear=1993
g wave=3
keep hid pid datayear wave doiy4 doim doid ivfio doby sex qfachi qfedhi paynu jbhrs jbotpd jbsect mlstat nchild fihhmn tenure region ///
    jbstat jbft age12 plbornc jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 jbsat jbterm jssat1 jssat2 jssat3 jssat4 jssat5 jssat jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic tuin1 jbonus jbopps jbmngr j2has age cjsten jbttwt jbpen sppayg spjbhr spjbot howlng ///
    jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk3", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\cjobhist"
renpfix c
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk3"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk3", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\chhsamp"
renpfix c
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk3"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk3", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\dindresp"
renpfix d
g datayear=1994
g wave=4
keep hid pid datayear wave doiy4 doim doid ivfio doby sex qfachi qfedhi paynu jbhrs jbotpd jbsect mlstat nchild fihhmn tenure region ///
    jbstat jbft age12 plbornc jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 jbsat jbterm jssat1 jssat2 jssat3 jssat4 jssat5 jssat jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic jbsic92 tuin1 jbonus jbopps jbmngr j2has age ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk4", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\djobhist"
renpfix d
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk4"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk4", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\dhhsamp"
renpfix d
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk4"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk4", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\eindresp"
renpfix e
g datayear=1995
g wave=5
keep hid pid datayear wave doiy4 doim doid ivfio doby sex qfachi qfedhi paynu jbhrs jbotpd jbsect mlstat nchild fihhmn tenure region ///
    jbstat jbft age12 plbornc jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 jbsat jbterm jssat1 jssat2 jssat3 jssat4 jssat5 jssat jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic tuin1 jbonus jbopps jbmngr j2has age cjsten jbttwt jbpen sppayg spjbhr spjbot howlng ///
    jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk5", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ejobhist"
renpfix e
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk5"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk5", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ehhsamp"
renpfix e
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk5"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk5", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\findresp"
renpfix f
g datayear=1996
g wave=6
keep hid pid datayear wave doiy4 doim doid ivfio doby sex qfachi qfedhi paynu jbhrs jbotpd jbsect mlstat nchild fihhmn tenure region ///
    jbstat jbft age12 plbornc jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 jbsat jssat1 jssat2 jssat3 jssat4 jssat5 jssat jbsoc ///
    lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbterm ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic tuin1 jbonus jbopps jbmngr j2has age cjsten jbttwt jbpen sppayg spjbhr spjbot howlng ///
    jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk6", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\fjobhist"
renpfix f
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk6"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk6", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\fhhsamp"
renpfix f
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk6"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk6", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\gindresp"
renpfix g
g datayear=1997
g wave=7
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi paynu jbhrs jbsect mlstat oprlg1 nchild fihhmn tenure ///
    region jbotpd jbstat jbft age12 plbornc jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 jbsat ///
    lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbterm jssat1 jssat2 jssat3 jssat4 jssat5 jssat jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic jbsic92 tuin1 jbonus jbopps jbmngr j2has age ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk7", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\gjobhist"
renpfix g
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk7"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk7", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ghhsamp"
renpfix g
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk7"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk7", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\hindresp"
renpfix h
g datayear=1998
g wave=8
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi edoql1 paynu jbsect mlstat nchild fihhmn tenure region ///
    jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc pargsc margsc jssat1 jssat2 jssat4 jssat5 jssat ///
    plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbterm jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic tuin1 jbonus jbopps jbmngr j2has age cjsten jbttwt jbpen sppayg spjbhr spjbot howlng ///
    jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk8", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\hjobhist"
renpfix h
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk8"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk8", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\hhhsamp"
renpfix h
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk8"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk8", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\iindresp"
renpfix i
g datayear=1999
g wave=9
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi edoql1 paynu jbsect mlstat oprlg1 nchild fihhmn tenure ///
    region jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc pargsc margsc jssat1 jssat2 jssat4 jssat5 jssat ///
    plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbterm1 jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbasp1 jbasp2 jbsic tuin1 jbonus jbopps jbmngr j2has age ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk9", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ijobhist"
renpfix i
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk9"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk9", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ihhsamp"
renpfix i
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk9"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk9", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\jindresp"
renpfix j
g datayear=2000
g wave=10
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi edoql1 paynu jbsect mlstat nchild fihhmn tenure region ///
    jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc pargsc margsc jssat1 jssat2 jssat4 jssat5 jssat ///
    plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbterm1 jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic tuin1 jbonus jbopps jbmngr j2has age cjsten jbttwt jbpen sppayg spjbhr spjbot howlng ///
    jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk10", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\jjobhist"
renpfix j
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk10"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk10", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\jhhsamp"
renpfix j
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk10"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk10", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\kindresp"
renpfix k
g datayear=2001
g wave=11
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi edoql1 paynu jbsect mlstat oprlg1 nchild fihhmn tenure ///
    region jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc pargsc margsc ///
    plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat jbterm1 jssat1 jssat2 jssat4 jssat5 jssat jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic jbsic92 tuin1 jbonus jbopps jbmngr j2has age ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk11", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\kjobhist"
renpfix k
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk11"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk11", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\khhsamp"
renpfix k
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk11"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk11", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\lindresp"
renpfix l
g datayear=2002
g wave=12
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi edoql1 paynu jbsect mlstat nchild fihhmn tenure region ///
    jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc pargsc margsc jssat1 jssat2 jssat4 jssat5 jssat ///
    plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbterm1 jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize race paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic jbsic92 tuin1 jbonus jbopps jbmngr j2has age ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk12", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ljobhist"
renpfix l
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk12"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk12", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\lhhsamp"
renpfix l
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk12"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk12", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\mindresp"
renpfix m
g datayear=2003
g wave=13
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi edoql1 paynu jbsect mlstat nchild fihhmn tenure region ///
    jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc sibs nsibs jssat1 jssat2 jssat4 jssat5 jssat ///
    fampos paby paagyb maby maagyb paedhi maedhi pargsc margsc lvag16 lvag14 ynlp14 ///
    plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbterm1 jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize racel paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic92 tuin1 jbonus jbopps jbmngr j2has age oprlg5 ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk13", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\mjobhist"
renpfix m
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk13"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk13", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\mhhsamp"
renpfix m
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk13"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk13", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\nindresp"
renpfix n
g datayear=2004
g wave=14
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi edoql1 paynu jbsect mlstat oprlg1 nchild fihhmn tenure ///
    region jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc jbterm1 jssat1 jssat2 jssat4 jssat5 jssat ///
    pargsc margsc plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbsoc ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize racel paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbasp1 jbasp2 jbsic92 tuin1 jbonus jbopps jbmngr j2has age ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk14", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\njobhist"
renpfix n
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk14"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk14", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\nhhsamp"
renpfix n
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk14"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk14", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\oindresp"
renpfix o
g datayear=2005
g wave=15
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi paynu jbsect mlstat nchild fihhmn tenure region ///
    jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc ///
    pargsc margsc plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat jbterm1 jssat1 jssat2 jssat4 jssat5 jssat ///
    lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jbsoc ///
    ptrt5a1 ptrt5c1 ptrt5e1 ptrt5n1 ptrt5o1 ptrt5a2 ptrt5c2 ptrt5e2 ptrt5n2 ptrt5o2 ptrt5a3 ptrt5c3 ptrt5e3 ptrt5n3 ptrt5o3 ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize racel paygu ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic92 tuin1 jbonus jbopps jbmngr j2has age oprlg5 ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk15", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ojobhist"
renpfix o
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk15"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk15", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\ohhsamp"
renpfix o
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk15"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk15", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\pindresp"
ren pid ppid
renpfix p
g datayear=2006
g wave=16
keep hid pid datayear wave doiy4 doim doid ivfio memorig doby sex qfachi qfedhi paynu jbsect mlstat nchild fihhmn tenure region ///
    jbhrs jbotpd jbstat jbft age12 paju pasemp pasoc maju masemp masoc paygu ///
    pargsc margsc plbornc jbsat2 jbsat4 jbsat6 jbsat7 jbsat jbterm1 jbsoc ///
    lfsat1 lfsat2 lfsat3 lfsat4 lfsat5 lfsat6 lfsat7 lfsat8 lfsato lfsatl jssat1 jssat2 jssat4 jssat5 jssat ///
    ivsoih ivsoim ivfoih ivfoim iv1 iv2 iv4 iv5 iv6a iv6b iv6c iv6d iv6e iv6f ivea iveb ivec ived ivee hlstat hhsize racel ///
    jbsize jbmngr jbttwt jbbgy vote4 sppayg jbsic92 tuin1 jbonus jbopps jbmngr j2has age oprlg5 ///
    cjsten jbttwt jbpen sppayg spjbhr spjbot howlng jbot jbhas jboff jbsemp jbbgly
so pid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk16", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\pjobhist"
ren pid ppid
renpfix p
keep pid jhstat jspno jhbgd jhbgm jhbgy
keep if jspno==1
so pid
merge pid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk16"
ta _merge
drop _merge
so hid
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk16", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\phhsamp"
renpfix p
keep hid ivid
so hid
merge hid using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk16"
ta _merge
keep if _merge==3
drop _merge
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk16", replace

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk1", clear
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk2"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk3"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk4"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk5"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk6"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk7"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk8"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk9"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk10"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk11"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk12"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk13"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk14"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk15"
compress
append using "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk16"
compress
duplicates report
duplicates drop
sa "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk", replace

erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk1.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk2.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk3.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk4.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk5.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk6.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk7.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk8.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk9.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk10.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk11.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk12.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk13.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk14.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk15.dta"
erase "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk16.dta"

u "D:\data\BHPS\WAVES_1-16\UKDA-5151-stata8\stata8\junk", clear

*******************************************************KEEP ORIGINAL ESSEX SAMPLE ONLY*******************************************************
replace memorig=1 if (memorig==. & datayear<1997)
drop if memorig!=1 // keep the original Essex sample only
*Wales and Scotland were added in wave 9[1999], and Northern Ireland in wave 11[2001].
bys wave: ta memorig
*********************************************************************************************************************************************

*********************************************************************************************************************************************
*****************************************************************Add CHAW********************************************************************

ren doby cohort
ren doiy4 year
la var year "Year of the Interview"
ren doim month
la var month "Month of the Interview"
so year month // I use the year and the month of the interview to deflate the wage
merge year month using "D:\DATA\rpi2008.dta"
ta _merge // _merge==3: (1) are cases with missing month of the interview, (2) are indices for other years
drop if _merge==2
replace paynu=. if _merge==1 // cannot be deflated
replace paygu=. if _merge==1
replace fihhmn=. if _merge==1
so pid wave
sa "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/BHPS.dta", replace

u "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/BHPS.dta", clear
tsset pid wave

aorder

**********************************************************************************************************************************************
****************************************************************Other controls****************************************************************

***(1)Gender
ta sex, m
g male=sex
recode male (2=0) (-7=.)
ta male, m

***(2)Age: note that Clark uses age of respondent at the date of the interview!
ren age int_age
ta age12, m
xtset pid wave
g dage=d.age12
ta dage, m
replace age12=. if dage!=1&dage!=.
ren age12 age
g age2=age^2
replace age2=age2/1000

***(3)Health: omitted category is fair to very poor health 
ta hlstat, m
recode hlstat (-9/0=.)
g exchealth=hlstat==1
replace exchealth=. if hlstat==.
g goodhealth=hlstat==2
replace goodhealth=. if hlstat==.
ta exchealth, m
ta goodhealth, m

***(4)Education: omitted category is low qualifications
ta qfedhi, m
recode qfedhi (-9/0=.)
g highed=qfedhi==1
replace highed=1 if qfedhi==2|qfedhi==3|qfedhi==4 // higher degree, first degree, teaching qualification or other higher qualification
replace highed=1 if pid==13597302 // this goes from "other high qualification" to "no qualification"!!!
replace highed=1 if pid==18459722 // this goes from "first degree" to "no qualification"!!
*Note: I spotted these as they had a min. negative within-variation, using the command: bys pid:g uff=highed<highed[_n-1]&highed[_n-1]!=.
replace highed=. if qfedhi==.
g meded=qfedhi==5
replace meded=1 if qfedhi==6|qfedhi==7 // nursing qualification, A-level, O-level or equivalent
*Instead, it is possible for meded to go from 1 to 0, in case somebody acquires a higher qualification.
replace meded=. if qfedhi==.
ta highed, m
ta meded, m

***(5)Race: I have checked that it is time-invariant
ta race, m
ta racel, m
g indi=race==5
replace indi=1 if race==6|race==7|racel==10|racel==11|racel==12|racel==13 // Indian, Pakistani or Bangladeshi
bys pid: egen indian=max(indi) // as it is not repeated every wave
so pid wave
g blac=race==2
replace blac=1 if race==3|race==4| racel==14|racel==15|racel==16 // Black Caribbean, Black African or other black group
bys pid: egen black=max(blac) // as it is not repeated every wave
so pid wave
ta indian, m
ta black, m

***(6)Marital status: omitted category is never married
ta mlstat, m
recode mlstat (-9/0=.)
g marr=mlstat==1
replace marr=. if mlstat==.
g sepdiv=mlstat==2
replace sepdiv=1 if mlstat==3
replace sepdiv=. if mlstat==.
g wid=mlstat==4
replace wid=. if mlstat==.
ta marr, m
ta sepdiv, m
ta wid, m

***(7)Housing tenure
ta tenure, m
recode tenure (-9/0=.)
g rent=tenure==3
replace rent=1 if tenure==4|tenure==5|tenure==6|tenure==7|tenure==8
replace rent=. if tenure==.
ta rent, m

***(8)Regions: omitted category is InLondon
ta region, m
recode region (-9/0=.)
ta region, g(reg)
ren reg1 InLondon
ren reg2 OutLondon
ren reg3 SEast
ren reg4 SWest
ren reg5 EAnglia
ren reg6 EMidlands
ren reg7 WMidlandsCon
ren reg8 WMidlands
ren reg9 Manchester
ren reg10 Mersey
ren reg11 NWest
ren reg12 SYork
ren reg13 WYork
ren reg14 York_Humber
ren reg15 Tyne_Wear
ren reg16 North
ren reg17 Wales
ren reg18 Scotland

***(9)Hourly wage
ta jbotpd, m
replace jbotpd=0 if jbotpd<0 // otherwise Stata does not construct the wage!
ta jbotpd, m
su paynu, d
replace paynu=. if paynu<=0 // [-9]: missing or wild; [-8]: inapplicable; [-7]: proxy respondent
su paynu, d
ta jbhrs, m
g hours=jbhrs
replace jbhrs=0 if jbhrs<0 // otherwise Stata does not construct the wage!
ta jbhrs, m
g nhw=(paynu/(jbhrs+1.5*jbotpd))*1/4.33
replace nhw=. if nhw==0
la var nhw "Nominal hourly net wage"
su nhw, d
g rhw=nhw*rpi2005
la var rhw "Real hourly net wage with base 2005"
su rhw, d
egen p1=pctile(rhw),p(1)
egen p99=pctile(rhw),p(99)
replace rhw=. if rhw<p1
replace rhw=. if rhw>p99
g lhw=ln(rhw)
la var lhw "Real hourly net log wage with base 2005"
su lhw, d

***(10)Family income 
su fihhmn, d
g hhinc=fihhmn
replace hhinc=. if hhinc<=0
replace hhinc=hhinc*rpi2005
la var hhinc "Real household income with base 2005"
su hhinc, d
g lhhinc=ln(hhinc)
la var lhhinc "Real household log income with base 2005"
su lhhinc, d

***(11)Monthly wage 
su paygu, d
replace paygu=. if paygu<=0 // [-8]: inapplicable; [-7]: proxy respondent
g rmw=paygu*rpi2005
la var rmw "Real monthly gross wage with base 2005"
su rmw, d
egen p1m=pctile(rmw),p(1)
egen p99m=pctile(rmw),p(99)
replace rmw=. if rmw<p1
replace rmw=. if rmw>p99
g lmw=ln(rmw)
la var lmw "Real monthly log gross wage with base 2005" // used by Clark
su lmw, d

***(12)Hours of work: they do not include neither overtime, nor meal breaks.
ta hours, m
*[-9]: missing or wild; [-8]: inapplicable; [-2]: refused; [-1]: don't know; [0]: inapplicable
recode hours (61/99=60) (-9=.) (-8=0) (-2=.) (-1=.)
g lhrs=ln(hours) // so the 0s are automatically dropped

***(13)Hours worked overtime
ta jbot, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know; [0]: none
recode jbot (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
ta jbot, m

***(14)Industry dummies: use waves 4-7-11 where both the old and the new sic are reported, to map the old into the new one for the early waves
ta jbsic, m

***(15)Occupation: omitted category is other (9) or inapplicable (-8=10)
ta jbsoc, m
recode jbsoc (100/199=1) (200/299=2) (300/399=3) (400/499=4) (500/599=5) (600/699=6) (700/799=7) (800/899=8) (900/999=9) (-9=.) (-8=10) ///
    (-7/-1=.)
la de jbsoc 1 "manag&adm" 2 "professional" 3 "assprof&tech" 4 "cler&secr" 5 "craft" 6 "pers&prot" 7 "sales" 8 "plant" 9 "other", modify
la val jbsoc jbsoc
ta jbsoc, g(sc)
ren sc1 manager
ren sc2 profess
ren sc3 technic
ren sc4 cleric
ren sc5 craft
ren sc6 person
ren sc7 sales
ren sc8 plant
ta manager, m
ta profess, m
ta technic, m
ta cleric, m
ta craft, m
ta person,
ta sales, m
ta plant, m

***(16)Establishment size: omitted category is 200+ workers
ta jbsize, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode jbsize (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
g smallfirm=jbsize==1
replace smallfirm=1 if jbsize==2|jbsize==3
replace smallfirm=. if jbsize==.
la var smallfirm "Less than 25 workers"
g medfirm=jbsize==4
replace medfirm=1 if jbsize==5|jbsize==6
replace medfirm=. if jbsize==.
la var medfirm "Between 25 and 200 workers"
ta smallfirm, m
ta medfirm, m

***(17)Union member
ta tuin1, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode tuin1 (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
g union=tuin1==1
replace union=. if tuin1==.
ta union, m

***(18)Incentive payment - no longer used (SP decision)
ta jbonus, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode jbonus (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
so pid wave
bys pid: replace jbonus=jbonus[_n-1] if jbonus==.&(wave==2|wave==3)
so pid wave
g bonus=jbonus==1
replace bonus=. if jbonus==.
ta bonus, m

***(19)Promotion opportunities
ta jbopps, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode jbopps (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
so pid wave
bys pid: replace jbopps=jbopps[_n-1] if jbopps==.&(wave==2|wave==3)
so pid wave
g promopp=jbopps==1
replace promopp=. if jbopps==.
ta promopp, m

***(20)Part-time job
ta jbft, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode jbft (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
g pt=jbft==2
replace pt=. if jbft==.
ta pt, m

***(21)Religion 
ta oprlg1, m
bys pid: egen relig=max(oprlg1)
so pid wave
recode relig (-9/0=.)
ta relig
g othrel=.
replace othrel=1 if relig>=1&relig<=14
replace othrel=0 if relig==1
ta othrel

***(22)Influences on the interview
ta iv2, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode iv2 (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
g othinflint=iv2==1|iv2==2 // a great deal, a fair amount
replace othinflint=. if iv2==.
ta othinflint, m

***(23)Cooperation of the respondent
ta iv4, m
recode iv4 (-9=.) // missing or wild
g nocoopint=iv4==3|iv4==4|iv4==5 // fair, poor, very poor
replace nocoopint=. if iv4==.
ta nocoopint, m

***(24)Presence of the partner during the interview
ta iveb, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode iveb (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
*Partner present=1 in wave 1; 2 in wave 2 and 3
g partnpresint=iveb==1|iveb==2
replace partnpresint=. if iveb==.
ta partnpresint, m

***(25)Presence of children during the interview
ta ived, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode ived (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
g childpresint=ived==1|ived==4 // same as above
replace childpresint=. if ived==.
ta childpresint, m

***(26)Order of the interview
ta ivsoih, m
replace ivsoih=. if ivsoih<0 // ok, the negative values are only missing values - same for all the time of interview measures
g startint=ivsoih*60 // conversion of hour of start into minutes
ta ivfoih, m
replace ivfoih=. if ivfoih<0 // lots of missings in wave 3!
ta ivsoim, m
replace ivsoim=. if ivsoim<0
ta ivfoim, m
replace ivfoim=. if ivfoim<0 // lots of missings in wave 3!
replace ivfoih=24 if ivfoih==0 // otherwise the duration of the interview is a negative number
replace ivfoih=25 if ivfoih==1&ivsoih==23 // starts at 23 and ends at 1am
replace ivfoih=25 if ivfoih==1&ivsoih==22
g endint=ivfoih*60 // conversion of hour of end into minutes
replace startint=startint+ivsoim // add minutes of start
replace endint=endint+ivfoim // add minutes of end
g durint=endint-startint
ta durint, m
so pid wave
l pid wave doid ivsoih ivsoim ivfoih ivfoim startint endint durint if durint<0
replace durint=. if durint<0 // SOME WEIRD CASES...
bys hid wave: egen orderint=rank(startint)
ta orderint, m
bys hid wave: egen neworderint=rank(doid) if orderint==1.5|orderint==2.5|orderint==3.5|orderint==4.5|orderint==5.5|orderint==6.5
*Rank by day of interview and by end of interview in case of ties
replace orderint=neworderint if orderint==1.5|orderint==2.5|orderint==3.5|orderint==4.5|orderint==5.5|orderint==6.5
bys hid wave: egen newneworderint=rank(endint) if orderint==1.5|orderint==2.5|orderint==3.5|orderint==4.5|orderint==5.5|orderint==6.5
replace orderint=newneworderint if orderint==1.5|orderint==2.5|orderint==3.5|orderint==4.5|orderint==5.5|orderint==6.5
ta orderint, m
replace orderint=. if orderint==1.5|orderint==3.5 // the remaining few cases with ties
so pid wave

***(27)Interviewer id
encode ivid, g(intid)
bys pid: g sameint=intid==intid[_n-1]
ta sameint, m
so pid wave

***(28)Household size 
ta hhsize, m // no missings!
g onephh=hhsize==1 // self-completion filled after the interview
recode hhsize (9/14=8)

***(29)Job tenure
su cjsten, d
replace cjsten=0 if cjsten==-9&wave==16 // MANY MISSINGS FOR TENURE IN WAVE 16!
replace cjsten=. if cjsten<0 // [-9] or [-7] only
su cjsten, d
g yrten=cjsten/365 // convert in years
su yrten, d
replace yrten=. if yrten>age 
su yrten, d

***(30)Commuting time
ta jbttwt, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-3]: period uncodeable; [-2]: refused; [-1]: don't know
recode jbttwt (-9=.) (-8=0) (-7=.) (-3=.) (-2=.) (-1=.)
g comtime=jbttwt
recode comtime (200/600=200) 
replace comtime=comtime/10
ta comtime, m

***(31)Wave dummies
ta wave, g(w)

***(32)Sector
ta jbsect, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
recode jbsect (-9=.) (-8=0) (-7=.) (-2=.) (-1=.)
g sector=.
replace sector=jbsect if jbsect!=.
so pid wave
bys pid: replace sector=sector[_n-1] if sector==.&(wave==2|wave==3|wave==4)
so pid wave
*In the documentation it is said that only waves 2/4 are imputed
la de sector 1 "private firm/company" 2 "civil srv/cntrl govt" 3 "local govt/town hall" 4 "nhs or higher educ" 5 "natnalised industry" ///
    6 "non-profit orgs." 7 "armed forces" 8 "other", modify
la val sector sector
g nonprof=sector==6
replace nonprof=. if sector==.
ta nonprof, m

***(33)Born abroad 
ta plbornc, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy
recode plbornc (-8=0) // so I avoid that the proxies [-7] appear as the biggest value and get dropped, as this is time-invariant
bys pid: egen foreign=max(plbornc) // so the 0s are the English
so pid wave
recode foreign (-9=.) (-7=.)
ta foreign
g babroad=.
replace babroad=1 if foreign>0&foreign!=.
replace babroad=0 if foreign==0
ta babroad

***(34)Job change
ta jbbgly, m
*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy
recode jbbgly (-9=.) (-8=0) (-7=.)
g jobch=jbbgly==2 if jbbgly!=.
la var jobch "Job changed in last year"
so pid wave
bys pid: g jobchty=jobch[_n+1]
la var jobchty "Job change this year"
so pid wave
bys pid: g jobchny=jobch[_n+2]
la var jobchny "Job change next year"
so pid wave

***(35)Employer change
ta jhstat, m
*[-9]: missing or wild; [-2]: refused; [-1]: missing
recode jhstat (-9=.) (-2=.) (-1=.)
g empch=.
la var empch "Employer changed in last year"
replace empch=1 if jbbgly==2&jhstat==2
replace empch=0 if jbbgly==2&jhstat!=2&jhstat!=.
replace empch=0 if jbbgly==1
g newjob=.
la var newjob "New employer in last year"
replace newjob=1 if jbbgly==2&jhstat!=1&jhstat!=.
replace newjob=0 if jbbgly==2&jhstat==1
replace newjob=0 if jbbgly==1
so pid wave
bys pid: g newjobty=newjob[_n+1]
la var newjobty "New employer this year"
so pid wave
bys pid: g newjobny=newjob[_n+2]
la var newjobny "New employer next year"
so pid wave

***(36)New job, same employer
g newjobsame=.
la var newjobsame "New job, same employer in last year"
replace newjobsame=1 if jbbgly==2&jhstat==1
replace newjobsame=0 if jbbgly==2&jhstat!=1&jhstat!=.
replace newjobsame=0 if jbbgly==1

/*
sort pid wave
by pid: gen empch12=empch[_n+1] if wave==1
sort pid wave
by pid: gen empch23=empch[_n+1] if wave==2
sort pid wave
by pid: gen empch34=empch[_n+1] if wave==3
gen nextyrempch=empch12 if wave==1
replace nextyrempch=empch23 if wave==2
replace nextyrempch=empch34 if wave==3
*/

***CHECK ON MISSINGS
insp male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess ///
    technic cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland jobchny jobchty
insp male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess ///
    technic cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland jobchny jobchty if wave==15
*TO BE USED AS A CHECK AGAINST WAVE 16 WHICH IS HIGHLY PROBLEMATIC! (dropped as preliminary)
insp male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess ///
    technic cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland jobchny jobchty if wave==16

***SATISFACTION VARIABLES - SIMPLE CHECKS BEFORE RECODING
ta jbsat
ta lfsat5 // note the lack of "inapplicable"
ta jbsat lfsat5 // note this is automatically done only for waves >=6
ta jbsemp jbstat, row col 
ta jbstat jbsat
ta jbstat lfsat5
ta jbsemp jbsat
ta jbsemp lfsat5
ta lfsat5 if jbsat==-8 // lfsat5 simply refers to "job", so people have to decide whether to fill it in or not
*Employees and self-employed are the only two categories which are asked questions on job satisfaction
ta lfsat5 if jbsat<=0&jssat<=0&lfsat5>0 // so sure the SC one is the only job-satisfaction question answered
ta lfsat5 if jbsat>0&lfsat5>0 // in this case they have answered two: benchmark

***Compare those who replied to jbsat but not lfsat5 with those who replied to both
ta jbsat if lfsat5<=0&wave>5&jbsat>0
ta jbsat if lfsat5>0&wave>5&jbsat>0

***Compare those who replied to lfsat5 but not jbsat with those who replied to both
ta jbsat if jbsat<=0&lfsat5>0
ta lfsat5 if jbsat<=0&lfsat5>0
ta lfsat5 if jbsat>0&lfsat5>0

*[-9]: missing or wild; [-8]: inapplicable; [-7]: proxy; [-2]: refused; [-1]: don't know
replace jbsat=. if jbsat<=0
replace lfsat5=. if lfsat5<=0
ta jbsat lfsat5, row col

**************************************KEEP ONLY THOSE WITH VALID ANSWERS TO BOTH SATISFACTION QUESTIONS***************************************
drop if lfsat5==.|jbsat==.
*ALSO: THIS EXCLUDES WAVES 1-5 AND WAVE 11, WHEN THE NORTHERN IRELAND SAMPLE (NHPS) WAS ADDED
**********************************************************************************************************************************************

******************************************************REMOVE WAVE 16 AS PRELIMINARY RELEASE***************************************************
drop if wave==16
**********************************************************************************************************************************************

***Differences between the two measures
g diffsat=jbsat-lfsat5
su diffsat, d
ta diffsat

g dsat=diffsat
replace dsat=1 if diffsat<0 // under-reporting
replace dsat=2 if diffsat>0 // over-reporting
la de dsat 1 "lfsat5>jbsat" 2 "jbsat>lfsat5", modify
la val dsat dsat
bys wave male: ta dsat
so pid wave
g adiffsat=abs(diffsat)
ta diffsat
ta adiffsat
recode diffsat (-6/-5=-4) (5/6=4)
recode adiffsat (5/6=4)
ta diffsat
ta adiffsat
g disat=adiffsat
replace disat=1 if adiffsat>1&adiffsat!=.

xtsum male indian black age age2 highed meded marr sepdiv wid rent lhw lhhinc lhrs manager profess technic ///
    cleric craft person sales plant smallfirm medfirm union promopp nonprof pt jbot yrten comtime hhsize ///
    othinflint nocoopint partnpresint childpresint orderint sameint OutLondon SEast SWest EAnglia EMidlands WMidlandsCon ///
    WMidlands Manchester Mersey NWest SYork WYork York_Humber Tyne_Wear North Wales Scotland w6-w10 w12-w14

cou
bys pid: egen nwaves=count(wave)
so pid wave
ta nwaves
sa "C:\Documents and Settings\Gabriella\My Documents\RESEARCH\PAPERS\SATIS/SATIS.dta", replace
