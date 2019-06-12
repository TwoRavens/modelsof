* Selecting for Shame: The Monitoring of Workers' Rights by International Labour Organization, 1989 t0 2011. 

* STATA 14

/*
Stage1 data = CEACR actions
Stage2 data = CAS actions
*/

* Table 3 (and Appendix C) Using Stage1 & Stage2 data

* Model1 1
use stage1.dta
oprobit stage1 loglcinc lloggdpcapitaconstant  lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.lstage1 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP i.lagC87 i.lagC98 i.lagC29 i.lagC105 i.lagC138 i.lagC100 i.lagC111 time_trend  i.year, vce(cl ccode)

* Model2
use stage2.dta
oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.CeacrO87 i.CeacrO98 i.CeacrO29 i.CeacrO105 i.CeacrO138 i.CeacrO100 i.CeacrO111  CeacrDFall  i.lstage2  lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP countlWorker0 countlWorker1 time_trend i.year, vce(cl ccode)

* Model3  
use stage2.dta
oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 CeacrOall i.CeacrDF87 i.CeacrDF98 i.CeacrDF29 i.CeacrDF105 i.CeacrDF138 i.CeacrDF100 i.CeacrDF111  i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP countlWorker0 countlWorker1 time_trend i.year, vce(cl ccode)

* Model4 
use stage2.dta
oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.CeacrO87 i.CeacrO98 i.CeacrO29 i.CeacrO105 i.CeacrO138 i.CeacrO100 i.CeacrO111 i.CeacrDF87 i.CeacrDF98 i.CeacrDF29 i.CeacrDF105 i.CeacrDF138 i.CeacrDF100 i.CeacrDF111 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP countlWorker0 countlWorker1 time_trend i.year, vce(cl ccode)


* Table 4 (Appendix F, G and H) Using Stage1 and Stage2 data
 
* Model 1 
use stage1.dta
quietly oprobit stage1 loglcinc lloggdpcapitaconstant  lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.lstage1 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP i.lagC87 i.lagC98 i.lagC29 i.lagC105 i.lagC138 i.lagC100 i.lagC111  time_trend i.year, vce(cl ccode)
mchange, stats(se, p) 

* Model 2, 
use stage2.dta
quietly oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.CeacrO87 i.CeacrO98 i.CeacrO29 i.CeacrO105 i.CeacrO138 i.CeacrO100 i.CeacrO111  CeacrDFall  i.lstage2  lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP time_trend i.year, vce(cl ccode)
mchange, stats(se, p) 
 
* Model 3,  
use stage2.dta
quietly oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 CeacrOall i.CeacrDF87 i.CeacrDF98 i.CeacrDF29 i.CeacrDF105 i.CeacrDF138 i.CeacrDF100 i.CeacrDF111  i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP  time_trend i.year, vce(cl ccode)
mchange, stats(se, p) 

* Model 4,  
use stage2.dta
quietly oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.CeacrO87 i.CeacrO98 i.CeacrO29 i.CeacrO105 i.CeacrO138 i.CeacrO100 i.CeacrO111 i.CeacrDF87 i.CeacrDF98 i.CeacrDF29 i.CeacrDF105 i.CeacrDF138 i.CeacrDF100 i.CeacrDF111 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP  time_trend i.year, vce(cl ccode)
mchange, stats(se, p) 

* Appendix B Using Stage1 and Stage2 data
use stage1.dta
heckoprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.CeacrO87 i.CeacrO98 i.CeacrO29 i.CeacrO105 i.CeacrO138 i.CeacrO100 i.CeacrO111 i.CeacrDF87 i.CeacrDF98 i.CeacrDF29 i.CeacrDF105 i.CeacrDF138 i.CeacrDF100 i.CeacrDF111 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP countlWorker0 countlWorker1 noyrsCIRI noyrsCIRI_lWorker0  noyrsCIRI_lWorker1 time_trend, select(stage1heck12=loglcinc lloggdpcapitaconstant  lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.lstage1 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP i.lagC87 i.lagC98 i.lagC29 i.lagC105 i.lagC138 i.lagC100 i.lagC111 noyrsCIRI noyrsCIRI_lWorker0  noyrsCIRI_lWorker1 time_trend) 

* Appendix D Using Stage1 and Stage2 data

* Model 1 
use stage1.dta
oprobit stage1 loglcinc lloggdpcapitaconstant  lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.lstage1 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP i.lagC87 i.lagC98 i.lagC29 i.lagC105 i.lagC138 i.lagC100 i.lagC111 noyrsCIRI noyrsCIRI_lWorker0  noyrsCIRI_lWorker1 time_trend i.year, vce(cl ccode)

* Model 2 
use stage2.dta
oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.CeacrO87 i.CeacrO98 i.CeacrO29 i.CeacrO105 i.CeacrO138 i.CeacrO100 i.CeacrO111 i.CeacrDF87 i.CeacrDF98 i.CeacrDF29 i.CeacrDF105 i.CeacrDF138 i.CeacrDF100 i.CeacrDF111n i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP countlWorker0 countlWorker1 noyrsCIRI noyrsCIRI_lWorker0  noyrsCIRI_lWorker1  time_trend i.year, vce(cl ccode)

* Appendix E Using Stage1 and Stage2 data

* Model1 use stage1
use stage1.dta
oprobit stage1 loglcinc lloggdpcapitaconstant  lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.lstage1 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP i.lagC87 i.lagC98 i.lagC29 i.lagC105 i.lagC138 i.lagC100 i.lagC111 time_trend  i.year, vce(cl ccode)

* Model2 use stage2
use stage2.dta
oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.CeacrO87 i.CeacrO98 i.CeacrO29 i.CeacrO105 i.CeacrO138 i.CeacrO100 i.CeacrO111  CeacrDFall  i.lstage2  lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP countlWorker0 countlWorker1 time_trend i.year, vce(cl ccode)

* Model3 use stage2
use stage2.dta
oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 CeacrOall i.CeacrDF87 i.CeacrDF98 i.CeacrDF29 i.CeacrDF105 i.CeacrDF138 i.CeacrDF100 i.CeacrDF111  i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP countlWorker0 countlWorker1 time_trend i.year, vce(cl ccode)

* Model4 use stage2
use stage2.dta
oprobit stage2 loglcinc lloggdpcapitaconstant lUSalign lUSmilaid  i.lleft i.lWorker0 i.lWorker1 i.CeacrO87 i.CeacrO98 i.CeacrO29 i.CeacrO105 i.CeacrO138 i.CeacrO100 i.CeacrO111 i.CeacrDF87 i.CeacrDF98 i.CeacrDF29 i.CeacrDF105 i.CeacrDF138 i.CeacrDF100 i.CeacrDF111 i.lstage2 lpolity2 llogtrade lngo i.EUR i.AFR i.MEA i.SCA i.EAP countlWorker0 countlWorker1 time_trend i.year, vce(cl ccode)
