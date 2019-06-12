set more off
use Arriola_Johnson_AJPS.dta, clear
capture log using Arriola_Johnson_AJPS_log.txt, replace t

/**************************************************************REPLICATION CODE & DATA (21 August 2013)

Leonardo R. Arriola and Martha C. Johnson. 2013. "Ethnic Politics and Women's Empowerment in Africa: Ministerial Appointments to Executive Cabinets." American Journal of Political Science. Forthcoming.

All analysis was conducted in Stata 12.1.

Filename: Arriola_Johnson_AJPS.do

Data Used: Arriola_Johnson_AJPS.dta

Data Note: Variable definitions can be found using Stata's 'describe' command. Variable descriptions and sources are found in the accompanying codebook (Arriola_Johnson_AJPS_codebook.pdf). For questions, contact: larriola@berkeley.edu or majohnson@mills.edu.

File Output: 
(1) Arriola_Johnson_AJPS_log.txt [log file]
(2) Arriola_Johnson_table1.doc [Article Table 1]
(3) Arriola_Johnson_table2.doc [Article Table 2]
(4) Arriola_Johnson_table3.doc [Article Table 3]
(5) Arriola_Johnson_tableF.doc [Supporting Information Appendix F]
(6) Arriola_Johnson_tableG.doc [Supporting Information Appendix G]
(7) Arriola_Johnson_tableH.doc [Supporting Information Appendix H]
(8) Arriola_Johnson_tableI.doc [Supporting Information Appendix I]
(9) Arriola_Johnson_tableJ.doc [Supporting Information Appendix J]
(10) Arriola_Johnson_tableK.doc [Supporting Information Appendix K]
(11) Arriola_Johnson_tableL.doc [Supporting Information Appendix L]
(12) Arriola_Johnson_tableM.doc [Supporting Information Appendix M]

**************************************************************/

tsset ccode year, yearly
/**************************************************************Table 1. Women's Share of Cabinet Portfolios (1980-2005)**************************************************************/

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.loggdp, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.loggdp)
outreg2 using Arriola_Johnson_table1.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_table1.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.loggdp, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.loggdp)
outreg2 using Arriola_Johnson_table1.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_table1.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Table 2. Women's Share of Cabinet Portfolios and Political Institutions (1995-2005)**************************************************************/

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.dpiparl l.dpimix if year>1994, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.dpiparl l.dpimix)
outreg2 using Arriola_Johnson_table2.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.govleg if year>1994, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.govleg)
outreg2 using Arriola_Johnson_table2.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.lpr l.ltrs l.lmix if year>1994, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.lpr l.ltrs l.lmix)
outreg2 using Arriola_Johnson_table2.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.enlp if year>1994, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.enlp)
outreg2 using Arriola_Johnson_table2.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Table 3. Women's Share of Cabinet Portfolios and Socio-economic Conditions (1980-2005)**************************************************************/

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.femlife, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.femlife)
outreg2 using Arriola_Johnson_table3.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.fertility, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.fertility)
outreg2 using Arriola_Johnson_table3.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.femlabor, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.femlabor)
outreg2 using Arriola_Johnson_table3.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.wosoc, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.wosoc)
outreg2 using Arriola_Johnson_table3.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Supporting Information: Appendix F. Women's Share of Cabinet Portfolios with Alternate Ethnicity Measures**************************************************************/

xtabond2 femshare l.egipgrps l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.egipgrps l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableF.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.elf l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.elf l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableF.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Supporting Information: Appendix G. Women's Share of Cabinet Portfolios with Alternate Democracy Measures**************************************************************/

xtabond2 femshare l.ethpreg l.fhpr l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.ethpreg l.fhpr l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableG.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.ethpreg l.stock l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.ethpreg l.stock l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableG.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.eiec l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.ethpreg l.eiec l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableG.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.fhpr l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.groups l.fhpr l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableG.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.stock l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.groups l.stock l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableG.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.eiec l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni, gmm(femshare, l(2 2)) iv(l.groups l.eiec l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableG.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Supporting Information: Appendix H. Women's Share of Cabinet Portfolios with Political Institutions & PREG**************************************************************/

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.dpiparl l.dpimix if year>1994, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.dpiparl l.dpimix)
outreg2 using Arriola_Johnson_tableH.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.govleg if year>1994, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.govleg)
outreg2 using Arriola_Johnson_tableH.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.lpr l.ltrs l.lmix if year>1994, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.lpr l.ltrs l.lmix)
outreg2 using Arriola_Johnson_tableH.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.enlp if year>1994, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.enlp)
outreg2 using Arriola_Johnson_tableH.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Supporting Information: Appendix I. Women's Share of Cabinet Portfolios with Socioeconomic Conditions & PREG**************************************************************/

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.femlife, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.femlife)
outreg2 using Arriola_Johnson_tableI.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.fertility, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.fertility)
outreg2 using Arriola_Johnson_tableI.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.femlabor, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.femlabor)
outreg2 using Arriola_Johnson_tableI.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.wosoc, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.postconfyrs l.musmaj l.nonmaj l.loggdp l.wosoc)
outreg2 using Arriola_Johnson_tableI.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Supporting Information: Appendix J. Women's Share of Cabinet Portfolios and Democracy Aid Measures**************************************************************/

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aid100, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aid100)
outreg2 using Arriola_Johnson_tableJ.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p120, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p120)
outreg2 using Arriola_Johnson_tableJ.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p121, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p121)
outreg2 using Arriola_Johnson_tableJ.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p130, gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p130)
outreg2 using Arriola_Johnson_tableJ.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aid100, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aid100)
outreg2 using Arriola_Johnson_tableJ.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p120, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p120)
outreg2 using Arriola_Johnson_tableJ.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p121, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p121)
outreg2 using Arriola_Johnson_tableJ.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p130, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.p130)
outreg2 using Arriola_Johnson_tableJ.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Supporting Information: Appendix K. Women's Share of Cabinet Portfolios with Dropped Countries**************************************************************/

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="Botswana", gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="Gambia", gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="South Africa", gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="Sudan", gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="Sudan" & country!="Botswana", gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="Botswana", gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="Gambia", gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="South Africa", gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="Sudan", gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.ethpreg l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni if country!="Sudan" & country!="Botswana", gmm(femshare, l(2 2)) iv(l.ethpreg l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.musmaj l.nonmaj l.loggdp l.aidgni)
outreg2 using Arriola_Johnson_tableK.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Supporting Information: Appendix L. Women's Share of Cabinet Portfolios: OLS, Fixed Effects, and GMM **************************************************************/

reg femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.loggdp
outreg2 using Arriola_Johnson_tableL.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtreg femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.loggdp, fe
outreg2 using Arriola_Johnson_tableL.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtabond2 femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.loggdp, gmm(femshare, l(2 2)) iv(l.groups l.polity2 l.yrsoffc l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.loggdp)
outreg2 using Arriola_Johnson_tableL.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

/**************************************************************Supporting Information: Appendix M. Women's Share of Cabinet Portfolios with Country Fixed Effects **************************************************************/

xtreg femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem, fe
outreg2 using Arriola_Johnson_tableM.doc, aster(coef) alpha(0.01, 0.05, 0.10) replace

xtreg femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.loggdp l.aidgni, fe
outreg2 using Arriola_Johnson_tableM.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtreg femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.loggdp l.aidgni l.fertility, fe
outreg2 using Arriola_Johnson_tableM.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtreg femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.loggdp l.aidgni l.femlabor, fe
outreg2 using Arriola_Johnson_tableM.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

xtreg femshare l.groups l.polity2 l.yrsoffc l.femshare l.parlfem l.mpfemyrs l.quota2 l.cedaw l.marxyrs l.postconfyrs l.loggdp l.aidgni l.p121, fe
outreg2 using Arriola_Johnson_tableM.doc, aster(coef) alpha(0.01, 0.05, 0.10) append

log close
