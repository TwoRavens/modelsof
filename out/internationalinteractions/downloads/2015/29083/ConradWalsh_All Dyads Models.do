version 12.1

set more off


*     ***************************************************************** *
*     ***************************************************************** *
*       File-Name:      ConradWalsh_All Dyads Models.do      *
*       Date:           11/2013                                         *
*       Author:         Justin Conrad & James Igoe Walsh                *
*	    Article:		International Cooperation, Spoiling and 		*
*						Transnational Terrorism                         *
*       Purpose:        Replicate all dyads models           *
*     ****************************************************************  *
*     ****************************************************************  *


***TABLE 1, MODEL 1****
nbreg terrorattack terrorattacklag1 terrorattacklag2 terrorattacklag3 terrorattacklag4 terrorattacklag5 powerratio2 rivlevelendure01 allies contig150 lndist jointdem majdyad dyadtrade  gpcasetarget2source gpcasetarget2sourcelag1 gpcasetarget2sourcelag2 gpcasetarget2sourcelag3 gncasetarget2source gncasetarget2sourcelag1 gncasetarget2sourcelag2 gncasetarget2sourcelag3, nolog robust cluster(ddyad)

***TABLE 1, MODEL 2********
nbreg terrorattack terrorattacklag1 terrorattacklag2 terrorattacklag3 terrorattacklag4 terrorattacklag5 powerratio2 rivlevelendure01 allies contig150 lndist jointdem majdyad dyadtrade  gpcumtarget2source gpcumtarget2sourcelag1 gpcumtarget2sourcelag2 gpcumtarget2sourcelag3 gncumtarget2source gncumtarget2sourcelag1 gncumtarget2sourcelag2 gncumtarget2sourcelag3, nolog robust cluster(ddyad)

***TABLE 3, MODEL 5****
nbreg totalattacks totalattackslag1 totalattackslag2 totalattackslag3 totalattackslag4 totalattackslag5 powerratio2 rivlevelendure01 allies contig150 lndist majdyad dyadtrade rgdp96p2 pop2 xconst2 PHYSINT2 gpcasetarget2source gpcasetarget2sourcelag1 gpcasetarget2sourcelag2 gpcasetarget2sourcelag3 gncasetarget2source gncasetarget2sourcelag1 gncasetarget2sourcelag2 gncasetarget2sourcelag3, nolog robust cluster(ddyad)

***TABLE 3, MODEL 6****
nbreg totalattacks totalattackslag1 totalattackslag2 totalattackslag3 totalattackslag4 totalattackslag5 powerratio2 rivlevelendure01 allies contig150 lndist majdyad dyadtrade rgdp96p2 pop2 xconst2 PHYSINT2 gpcumtarget2source gpcumtarget2sourcelag1 gpcumtarget2sourcelag2 gpcumtarget2sourcelag3 gncumtarget2source gncumtarget2sourcelag1 gncumtarget2sourcelag2 gncumtarget2sourcelag3, nolog robust cluster(ddyad)

exit
