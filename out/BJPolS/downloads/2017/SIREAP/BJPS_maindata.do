use "BJPS_maindata.dta", replace

 
*******************************************************************************
* Table 1 
*******************************************************************************

xi i.Year, prefix(yr_)
 
sort ID Year
xtset ID Year

eststo clear
quiet nbreg conflict l.logoilsales yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales yr_*, robust cluster(ID)
eststo

quiet nbreg conflict l.logoilsales l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo

quiet nbreg conflict l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo

esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex


*******************************************************************************
* Table 2
*******************************************************************************

**** Earlist oil/gas reserve sales

eststo clear

quiet nbreg conflict l.logoilresrsales1 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo
quiet nbreg conflict l.loggasresrsales1 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgasresrsales1 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo

**** Cloest oil/gas reserve sales to the year 1997

quiet nbreg conflict l.logoilresrsales2 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo
quiet nbreg conflict l.loggasresrsales2 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgasresrsales2 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo


**** for Average oil/gas reserve sales 

quiet nbreg conflict l.logoilresrsales3 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo
quiet nbreg conflict l.loggasresrsales3 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgasresrsales3 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo

esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table 3
*******************************************************************************
eststo clear
quiet nbreg conflict c.l.logoilsales##c.l.logmosdens yr_* , robust cluster(ID)
eststo 
quiet nbreg conflict c.l.loggassales##c.l.logmosdens  yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.logoilgassales##c.l.logmosdens  yr_*, robust cluster(ID)
eststo 

quiet nbreg conflict  c.l.logoilsales##c.l.logmosdens l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.loggassales##c.l.logmosdens l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.logoilgassales##c.l.logmosdens l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo 

quiet nbreg conflict  c.l.logoilsales##c.l.logmosdens l.p_Uighur  l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.loggassales##c.l.logmosdens l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.logoilgassales##c.l.logmosdens  l.p_Uighur  l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo 
esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex



*******************************************************************************
* Table 4
*******************************************************************************

eststo clear

quiet reg logmosdens c.logmdensity##c.l.logoilsales  yr_*
predict v2hat,residual
quiet nbreg conflict c.l.logmosdens##c.l.logoilsales v2hat yr_*,robust cluster(ID)
drop v2hat
eststo

quiet reg logmosdens c.logmdensity##c.l.logoilgassales yr_*
predict v2hat,residual
quiet nbreg conflict c.l.logmosdens##c.l.logoilgassales v2hat yr_*,robust cluster(ID)
drop v2hat
eststo

quiet reg logmosdens c.logmdensity##c.l.logoilsales l.p_Uighur l.density2 distance  yr_*
predict v2hat,residual
quiet nbreg conflict c.l.logmosdens##c.l.logoilsales l.p_Uighur l.density2 distance v2hat yr_*,robust cluster(ID)
drop v2hat
eststo

quiet reg logmosdens c.logmdensity##c.l.logoilgassales l.p_Uighur l.density2 distance  yr_*
predict v2hat,residual
quiet nbreg conflict c.l.logmosdens##c.l.logoilgassales l.p_Uighur l.density2 distance v2hat yr_*,robust cluster(ID)
drop v2hat
eststo

quiet reg  logmosdens c.logmdensity##c.l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_*
predict v2hat,residual
quiet nbreg conflict c.l.logmosdens##c.l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope v2hat yr_*,robust cluster(ID)
drop v2hat
eststo

quiet reg  logmosdens c.logmdensity##c.l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_*
predict v2hat,residual
quiet nbreg conflict c.l.logmosdens##c.l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope v2hat yr_*,robust cluster(ID)
drop v2hat
eststo

esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table 5
*******************************************************************************
* Security spending 
eststo clear

quiet xtreg logsecu l.logoilsales l.p_Uighur l.density2 l.logrevenue l.loggrant l.logpgdp l.bingtuan yr_*, fe robust cluster(ID)
eststo
quiet xtreg logsecu l.loggassales l.p_Uighur l.density2 l.logrevenue l.loggrant l.logpgdp l.bingtuan yr_*, fe robust cluster(ID)
eststo
quiet xtreg logsecu l.logoilgassales l.p_Uighur l.density2 l.logrevenue l.loggrant l.logpgdp l.bingtuan yr_*, fe robust cluster(ID)
eststo

*government revenue
quiet xtreg logrevenue l.logoilsales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg logrevenue l.loggassales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo
quiet xtreg logrevenue l.logoilgassales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo

 
esttab, drop(yr_* ) se(4) b(4) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table 6
*******************************************************************************
eststo clear
quiet xtreg logpop l.logoilsales l.density2 l.logmosdens l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg logpop l.logoilgassales l.density2 l.logmosdens l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg loghan l.logoilsales l.density2 l.logmosdens l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg loghan l.logoilgassales l.density2 l.logmosdens l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg loguighur l.logoilsales l.density2 l.logmosdens l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg loguighur l.logoilgassales l.density2 l.logmosdens l.bingtuan yr_*, fe robust cluster(ID)
eststo 
esttab, keep( L.logoilsales L.logoilgassales L.density2 L.logmosdens L.bingtuan _cons) se(4) b(4) star(* .1 ** .05 *** .01) tex
 
*******************************************************************************
* Table 7
*******************************************************************************

eststo clear
quiet xtreg logpgdp logoilsales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg logpgdp loggassales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg logpgdp logoilgassales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg employ_rate logoilsales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg employ_rate loggassales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg  employ_rate logoilgassales l.p_Uighur l.density2 l.bingtuan yr_*, fe robust cluster(ID)
eststo 
esttab, drop(yr_*) se(4) b(4) star(* .1 ** .05 *** .01) tex



**************
** APPENDIX **
**************

******************************************************************************
* Table A1
******************************************************************************
sort ID Year
xtset ID Year

quietly nbreg conflict l.logoilgassales l.p_Uighur l.density2 distance  yr_*,robust cluster(ID)
sum conflict logoilsales loggassales logoilgassales logmosdens logmdensity logoilreserve1 logoilreserve2 logoilreserve3 loggasreserve1 loggasreserve2 loggasreserve3 p_Uighur density2 ///
distance logrevenue loggrant logpgdp bingtuan slope if e(sample)

sutex  conflict logoilsales loggassales logoilgassales logmosdens logmdensity logoilreserve1 logoilreserve2 logoilreserve3 loggasreserve1 loggasreserve2 loggasreserve3 p_Uighur density2 ///
distance logrevenue loggrant logpgdp bingtuan slope if e(sample), minmax


******************************************************************************
* Table A2
******************************************************************************

***** Reserve closest to 1997
eststo clear
quiet nbreg conflict logoilreserve2  l.p_Uighur l.density2 distance yr_*,robust cluster(ID)
eststo
quiet nbreg conflict loggasreserve2 l.p_Uighur l.density2 distance yr_*,robust cluster(ID)
eststo

quiet nbreg conflict logoilreserve2 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo
quiet nbreg conflict loggasreserve2 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo

*****Average  reserve 
quiet nbreg conflict logoilreserve3  l.p_Uighur l.density2 distance yr_*,robust cluster(ID)
eststo
quiet nbreg conflict loggasreserve3 l.p_Uighur l.density2 distance yr_*,robust cluster(ID)
eststo

quiet nbreg conflict logoilreserve3 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo
quiet nbreg conflict loggasreserve3 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*,robust cluster(ID)
eststo

esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A3
*******************************************************************************
eststo clear
quiet nbreg conflict c.l.logoilsales##c.l.logpmos yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.loggassales##c.l.logpmos  yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.logoilgassales##c.l.logpmos  yr_*, robust cluster(ID)
eststo 

quiet nbreg conflict  c.l.logoilsales##c.l.logpmos l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.loggassales##c.l.logpmos l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.logoilgassales##c.l.logpmos l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo 

quiet nbreg conflict  c.l.logoilsales##c.l.logpmos l.p_Uighur  l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.loggassales##c.l.logpmos l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.logoilgassales##c.l.logpmos  l.p_Uighur  l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo 
esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A4
*******************************************************************************
 xi i.prefecture, prefix(pre_)
 
eststo clear
quiet reg logmosdens logmdensity  l.p_Uighur  distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_* pre_* ,robust cluster(ID)
eststo
quiet reg logchurtempdens logmdensity   l.p_Uighur  distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_* pre_*,robust cluster(ID)
eststo
quiet reg primapop logmdensity  l.p_Uighur distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_* pre_*,robust cluster(ID)
eststo
quiet reg middlepop logmdensity   l.p_Uighur  distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_* pre_*,robust cluster(ID)
eststo
quiet reg  peroffice logmdensity   l.p_Uighur  distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_* pre_*,robust cluster(ID)
eststo
quiet reg  logperexp logmdensity   l.p_Uighur  distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_* pre_*,robust cluster(ID)
eststo

esttab, drop(yr_* pre_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A8
*******************************************************************************
eststo clear
quiet nbreg conflict l.lognb_oil l.logoilsales  yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.lognb_gas l.loggassales  yr_*, robust cluster(ID)
eststo
quiet nbreg conflict  l.lognb_oil l.lognb_gas l.logoilgassales  yr_*, robust cluster(ID)
eststo

quiet nbreg conflict l.lognb_oil l.logoilsales  l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.lognb_gas l.loggassales  l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.lognb_oil l.lognb_gas l.logoilgassales  l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo

quiet nbreg conflict l.lognb_oil l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.lognb_gas l.loggassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.lognb_oil l.lognb_gas l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A9
*******************************************************************************
eststo clear
quiet nbreg conflict l.logoilsales neighboor_1 yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales neighboor_1 yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales neighboor_1 yr_*, robust cluster(ID)
eststo

quiet nbreg conflict l.logoilsales neighboor_1 l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales neighboor_1 l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales neighboor_1 l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo

quiet nbreg conflict l.logoilsales neighboor_1 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales neighboor_1 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales neighboor_1 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A10
*******************************************************************************
eststo clear
quiet nbreg conflict l.logpoilsales yr_* , robust cluster(ID)
eststo 
quiet nbreg conflict l.logpgassales  yr_* , robust cluster(ID)
eststo 
quiet nbreg conflict l.logpoilgassales  yr_*, robust cluster(ID)
eststo 

quiet nbreg conflict  l.logpoilsales l.p_Uighur l.density2 distance yr_* , robust cluster(ID)
eststo 
quiet nbreg conflict l.logpgassales l.p_Uighur l.density2 distance yr_* , robust cluster(ID)
eststo 
quiet nbreg conflict l.logpoilgassales l.p_Uighur l.density2 distance yr_* , robust cluster(ID)
eststo 

quiet nbreg conflict  l.logpoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_* , robust cluster(ID)
eststo 
quiet nbreg conflict l.logpgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_* , robust cluster(ID)
eststo 
quiet nbreg conflict  l.logpoilgassales  l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_* , robust cluster(ID)
eststo 
esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A11
*******************************************************************************

eststo clear
quiet nbreg N_conflict l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*, robust cluster(ID)
eststo
quiet nbreg N_conflict l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo

quiet nbreg im_N_conflict l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo
quiet nbreg im_N_conflict l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_*, robust cluster(ID)
eststo

quiet logit conflict_event l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope, robust cluster(ID)
eststo
quiet logit conflict_event l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope, robust cluster(ID)
eststo

quiet logit im_conflict_event l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope, robust cluster(ID)
eststo
quiet logit im_conflict_event l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope, robust cluster(ID)
eststo

esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A12
*******************************************************************************
eststo clear
quiet logit conflict2 l.logoilsales, robust cluster(ID)
eststo
quiet logit conflict2 l.loggassales , robust cluster(ID)
eststo
quiet logit conflict2 l.logoilgassales, robust cluster(ID)
eststo

quiet logit conflict2 l.logoilsales l.p_Uighur l.density2 distance, robust cluster(ID)
eststo
quiet logit conflict2 l.loggassales l.p_Uighur l.density2 distance, robust cluster(ID)
eststo
quiet logit conflict2 l.logoilgassales l.p_Uighur l.density2 distance, robust cluster(ID)
eststo

quiet logit conflict2 l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope, robust cluster(ID)
eststo
quiet logit conflict2 l.loggassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope, robust cluster(ID)
eststo
quiet logit conflict2 l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope, robust cluster(ID)
eststo
esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A13
*******************************************************************************
eststo clear

quiet nbreg conflict l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_* pre_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_* pre_*, robust cluster(ID)
eststo

quiet nbreg conflict logoilreserve1 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_* pre_*,robust cluster(ID)
eststo
quiet nbreg conflict loggasreserve1 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_* pre_*,robust cluster(ID)
eststo

quiet poisson conflict c.l.logoilsales##c.l.logmosdens l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_* pre_*, robust cluster(ID)
eststo 
quiet nbreg conflict c.l.logoilgassales##c.l.logmosdens  l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan slope yr_* pre_*, robust cluster(ID)
eststo 

quiet reg  logmosdens c.logmdensity##c.l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_* pre_*
predict v2hat,residual
quiet poisson conflict c.l.logmosdens##c.l.logoilsales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope v2hat yr_* pre_*,robust cluster(ID)
drop v2hat
eststo

quiet reg  logmosdens c.logmdensity##c.l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope  yr_* pre_*
predict v2hat,residual
quiet nbreg conflict c.l.logmosdens##c.l.logoilgassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope v2hat yr_* pre_*,robust cluster(ID)
drop v2hat
eststo

esttab, drop(yr_* pre_*) se(3) b(3) star(* .1 ** .05 *** .01) tex


*******************************************************************************
* Table A14
*******************************************************************************
eststo clear
quiet xtgee  conflict  l.logoilsales ,  family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 
quiet xtgee  conflict  l.loggassales , family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 
quiet xtgee  conflict  l.logoilgassales , family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 

quiet xtgee  conflict   l.logoilsales l.p_Uighur l.density2 distance, family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 
quiet xtgee  conflict  l.loggassales l.p_Uighur l.density2 distance , family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 
quiet xtgee  conflict  l.logoilgassales l.p_Uighur l.density2 distance , family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 

quiet xtgee  conflict  l.logoilsales l.p_Uighur  l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope , family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 
quiet xtgee  conflict l.loggassales l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope , family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 
quiet xtgee  conflict l.logoilgassales l.p_Uighur  l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope , family(nbinomial) link(log) corr(ar1) vce(robust) 
eststo 
esttab,  se(3) b(3) star(* .1 ** .05 *** .01) tex


*******************************************************************************
* Table A15
*******************************************************************************
eststo clear

quiet nbreg cumconflict sumlogoilsale averp_Uighur averdensity distance averlogrevenue  averloggrant averlogpgdp  averbingtuan slope if Year==2005 , robust cluster(ID)
eststo
quiet nbreg cumconflict sumloggassale averp_Uighur averdensity distance averlogrevenue  averloggrant averlogpgdp  averbingtuan slope if Year==2005 , robust cluster(ID)
eststo
quiet nbreg cumconflict sumlogoilgassales averp_Uighur averdensity distance averlogrevenue  averloggrant averlogpgdp  averbingtuan slope if Year==2005 , robust cluster(ID)
eststo

quiet nbreg cumconflict averlogoilsale averp_Uighur averdensity distance averlogrevenue  averloggrant averlogpgdp  averbingtuan slope if Year==2005 , robust cluster(ID)
eststo
quiet nbreg cumconflict averloggassale averp_Uighur averdensity distance averlogrevenue  averloggrant averlogpgdp  averbingtuan slope if Year==2005 , robust cluster(ID)
eststo
quiet nbreg cumconflict averlogoilgassales averp_Uighur averdensity distance averlogrevenue  averloggrant averlogpgdp  averbingtuan slope if Year==2005 , robust cluster(ID)
eststo

esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A16
*******************************************************************************
eststo clear
quiet nbreg conflict l.logoilsales l.logoilsales2 yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales  l.loggassales2 yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales l.logoilgassales2 yr_*, robust cluster(ID)
eststo

quiet nbreg conflict l.logoilsales l.logoilsales2 l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales  l.loggassales2  l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales l.logoilgassales2 l.p_Uighur l.density2 distance yr_*, robust cluster(ID)
eststo

quiet nbreg conflict l.logoilsales l.logoilsales2 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.loggassales  l.loggassales2  l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*, robust cluster(ID)
eststo
quiet nbreg conflict l.logoilgassales l.logoilgassales2 l.p_Uighur l.density2 distance l.logrevenue l.loggrant l.logpgdp l.bingtuan  slope yr_*, robust cluster(ID)
eststo
esttab, drop(yr_* ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*******************************************************************************
* Table A17
*******************************************************************************
eststo clear
quiet xtreg logoilsales l.conflict  yr_*, fe cluster(ID)
eststo 
quiet xtreg loggassales l.conflict yr_*, fe cluster(ID)
eststo 
quiet xtreg logoilgassales l.conflict  yr_*,fe cluster(ID)
eststo 

quiet xtreg logoilsales l.conflict l.logmosdens l.p_Uighur l.density2 yr_*, fe cluster(ID)
eststo 
quiet xtreg loggassales l.conflict l.logmosdens l.p_Uighur l.density2 yr_*, fe robust cluster(ID)
eststo 
quiet xtreg logoilgassales l.conflict l.logmosdens l.p_Uighur l.density2  yr_*, fe robust cluster(ID)
eststo 

quiet xtreg logoilsales l.conflict l.logmosdens l.p_Uighur l.density2 l.logrevenue l.loggrant l.logpgdp l.bingtuan yr_*, fe cluster(ID)
eststo 
quiet xtreg loggassales l.conflict l.logmosdens l.p_Uighur l.density2 l.logrevenue l.loggrant l.logpgdp l.bingtuan yr_*, fe robust cluster(ID)
eststo 
quiet xtreg logoilgassales l.conflict l.logmosdens l.p_Uighur l.density2 l.logrevenue l.loggrant l.logpgdp l.bingtuan yr_*, fe robust cluster(ID)
eststo 
esttab, drop(yr_*) se(3) b(3) star(* .1 ** .05 *** .01) tex
