
/* This is the do file for generating the results in:
	
	Indra de Soysa & Ragnhild Nordås. 2007. 'Islam's Bloody Innards? Religion and Political Terror, 1981–2000'
	International Studies Quarterly (December) */



************Table 1 of ISQ paper **************
xi: oprobit HRsd ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table100.rtf , nolabel 3aster replace

xi: oprobit HRsd mus pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table100.rtf , nolabel 3aster append

xi: oprobit HRsd LHRsd mus pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table100.rtf , nolabel 3aster append

xi: oprobit HRsd oic_dummy pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table100.rtf , nolabel 3aster append

xi: oprobit HRsd islamic80 catholic80 ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table100.rtf , nolabel 3aster append

**********summary stats and correlation in appendix***************
sum physint HRsd energyrentsgdp mus oic_dummy islamic70 islamic80 islamic90 mus pro catholic70 catholic80 catholic90 cat oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs if e(sample)
corr HRsd oic_dummy mus pro cat oth ioil lnksggdppc democ_dummy nafrme if e(sample)


********WEB APPENDIX---SENSITIVITY ANALYSES*************
**Test with regional dummies***
xi: quietly oprobit HRsd ioil nafrme latam asia ssafrica eeurop mus pro oth lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cluster(cow) 
outreg using table1.rtf , nolabel 3aster replace

***Test with energy rents replacing oil dummy***
xi: quietly oprobit HRsd energyrentsgdp mus pro oth lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cluster(cow)
outreg using table1.rtf , nolabel 3aster append

***test using democracy coded at polity value 3 ****
xi: quietly oprobit HRsd mus pro oth ioil lnksggdppc democ_dummy3 growth legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table1.rtf , nolabel 3aster append

**Test with democracy coded at olity value 8****
xi: quietly oprobit HRsd mus pro oth ioil lnksggdppc democ_dummy8 growth legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table1.rtf , nolabel 3aster append

***Test with democracy using entite polity2 scale****
xi: quietly oprobit HRsd mus pro oth ioil lnksggdppc polity2 growth legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table1.rtf , nolabel 3aster append


/*Linear regressions of Islam on Human Rights using PIR scale (PHYSINT)-----PCSE & reg(cl) models*/

quietly xtpcse physint l.physint mus pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year, pairwise corr(ar1)
outreg using table2.rtf , nolabel 3aster replace

xi: quietly reg physint l.physint mus pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table2.rtf , nolabel 3aster append

quietly xtpcse physint mus pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year, pairwise corr(ar1)
outreg using table2.rtf , nolabel 3aster replace

xi: quietly reg physint mus pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table2.rtf , nolabel 3aster append

quietly xtpcse physint oic_dummy ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year, pairwise corr(ar1)
outreg using table2.rtf , nolabel 3aster append

xi: quietly reg physint oic_dummy ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, cl(cow)
outreg using table2.rtf , nolabel 3aster append


*********SENSITIVITY with Linear estimations using PIR**************
xi: quietly xtpcse physint ioil nafrme latam asia ssafrica eeurop mus pro oth lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year, pairwise corr(ar1)
outreg using table3.rtf , nolabel 3aster replace
xi: quietly xtpcse physint energyrentsgdp mus pro oth lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year, pairwise corr(ar1)
outreg using table3.rtf , nolabel 3aster append
xi: quietly xtpcse physint mus pro oth ioil lnksggdppc democ_dummy3 growth legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year, pairwise corr(ar1)
outreg using table3.rtf , nolabel 3aster append
xi: quietly xtpcse physint mus pro oth ioil lnksggdppc democ_dummy8 growth legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year, pairwise corr(ar1)
outreg using table3.rtf , nolabel 3aster append
xi: quietly xtpcse physint mus pro oth ioil lnksggdppc polity2 growth legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs year, pairwise corr(ar1)
outreg using table3.rtf , nolabel 3aster append


xi: reg physint mus pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year, 
vif
predict fit
predict sdres, rstandard
pnorm sdres
twoway scatter sdres fit, mlabel(wbccode)
predict cook, cooksd

xi: reg physint mus pro oth ioil lnksggdppc growth democ_dummy legbrit legsoc iethfrac lnpop civil_war civpeaceyrs interstate_war intpeaceyrs i.year if cook<4/2433, cl(cow)

exit
