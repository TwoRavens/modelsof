
** Note: This file writes results to a single Excel table using the "outreg2" funciton.
** This is an add on package for STATA. You only need to install this once, which is done by typing:
** ssc install outreg 2
** More information is available at: http://repec.org/bocode/o/outreg2

set more off
** Table 2: Baseline for each of the rights

*1) political parties
clear
use m.vote.dta
ologit elecsd polpart polity2 lngdp lnpop iswar civilwar injud INGO_uia i.year, cluster(country)
outreg2 polpart polity2 lngdp lnpop iswar civilwar injud INGO_uia using "Table2.xls", nocons replace excel dec(3)

*2) worker
clear
use m.worker.dta
ologit worker tradeun_strike polity2 lngdp lnpop iswar civilwar injud INGO_uia i.year, cluster(country)
outreg2 tradeun_strike polity2 lngdp lnpop iswar civilwar injud INGO_uia using "Table2.xls", nocons append excel dec(3)

*3) assembly
clear
use m.assem.dta
ologit assn assem_assoc polity2 lngdp lnpop iswar civilwar injud INGO_uia i.year, cluster(country)
outreg2 assem_assoc polity2 lngdp lnpop iswar civilwar injud INGO_uia using "Table2.xls", nocons append excel dec(3)

*4) religion
clear
use m.rel.dta
ologit relfre relig polity2 lngdp lnpop iswar civilwar injud INGO_uia i.year, cluster(country)
outreg2 relig polity2 lngdp lnpop iswar civilwar injud INGO_uia using "Table2.xls", nocons append excel dec(3)

*5) expression
clear
use m.express.dta
ologit speech press_express polity2 lngdp lnpop iswar civilwar injud INGO_uia i.year, cluster(country)
outreg2 press_express polity2 lngdp lnpop iswar civilwar injud INGO_uia using "Table2.xls", nocons append excel dec(3)

*6) movement
clear
use m.move.dta
ologit move libmov polity2 lngdp lnpop iswar civilwar injud INGO_uia i.year, cluster(country)
outreg2 libmov polity2 lngdp lnpop iswar civilwar injud INGO_uia using "Table2.xls", nocons append excel dec(3)








