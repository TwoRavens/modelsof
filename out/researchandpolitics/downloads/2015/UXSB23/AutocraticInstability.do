
**************************************************************************
** AutocraticInstability.do						**
** Joseph Wright, josephgwright@gmail.com				**
** Date created: August 6, 2013						**
** Date updated: December 9, 2015					**
**									**
** Using files: 							**
**     AhmedAPSR.dta	(Ahmed replication data)			**
**     Archigos.do	(BdM & Smith replication code) 			**
**     archigos_original.dta						**
**     BdmSmithAJPS.dta	(BdM & Smith replication data)			**
**     cowcodes.do      (used by DPI.do)				**
**     DPI.do		(Ahmed replication code)			**
**     DPI2012.dta							**
**     GWFglobal.dta							**
**     Polity.do        (Morrison replication code)			**
**     Polity.dta							**
**									**
**************************************************************************

set more off
set scheme lean1

capture log close
log using AutocraticInstability.log, replace


do Polity

do Archigos

do DPI

do Svolik


******* The END ********


log close


