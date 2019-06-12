##Procedures for regression models## Data for Table 2

use "data set IPSR 2017 versione 5.dta", clear

. xtmixed partydispersion  if parties!=0 & women>0 ||_all:R.legislatura ||_all:R.parties ||nomeid:, var ml
estimates store modello0
 . xtmixed partydispersion  i.gender if parties!=0 & women>0 ||_all:R.legislatura ||_all:R.parties ||nomeid:, var ml
estimates store modello1
 . xtmixed partydispersion  i.gender tenure  i.parloffice c.partyexp##c.partyexp i.profession i.partyorg ideolpos partysize i.elsyst if parties!=0 & women>0 ||_all:R.legislatura ||_all:R.parties ||nomeid:, var ml
estimates store modello2
. xtmixed partydispersion   i.gender##c.percwomenparty i.gender##c.tenure c.partysize c.ideolpos   c.partyexp##c.partyexp i.partyorg i.profession  i.parloffice i.elsyst if parties!=0 & women>0 ||_all:R.legislatura ||_all:R.parties ||nomeid:, var ml
estimates store modello3
. xtmixed partydispersion   i.gender##c.percwomenparty##i.partyorg i.gender##c.tenure##i.partyorg c.partysize c.ideolpos    c.partyexp##c.partyexp i.partyorg i.profession  i.parloffice i.elsyst if parties!=0 & women>0 ||_all:R.legislatura ||_all:R.parties ||nomeid:, var ml
estimates store modello4
. xtmixed partydispersion   i.gender##c.percwomenparty##i.partyorg i.gender##c.tenure c.partysize c.ideolpos    c.partyexp##c.partyexp i.partyorg i.profession  i.parloffice i.elsyst if parties!=0 & women>0 ||_all:R.legislatura ||_all:R.parties ||nomeid:, var ml
estimates store modello5


outreg2 [modello0 modello1 modello2 modello3 modello4 modello5] using tabella.xml, excel replace ///
title("TABLE: Gender and predictors of Party Cohesion") stats(coef se) /// 
sortvar(gender tenure parloffice partyexp profession ideolpos  partyorg percwomenparty partysize elsyst)  



##Procedure for marginal impacts## Data for Fig. 5a and Fig.5b 

use "data set IPSR 2017 versione 5.dta", clear

. xtmixed partydispersion   i.gender##c.percwomenparty##i.partyorg i.gender##c.tenure c.partysize c.ideolpos    c.partyexp##c.partyexp i.partyorg i.profession  i.parloffice i.elsyst if parties!=0 & women>0 ||_all:R.legislatura ||_all:R.parties ||nomeid:, var ml
 
 margins, dydx(gender) at(percwomenparty =(.0153846  (0.01) 0.5) partyorg=(0 1)) 
 marginsplot, by(partyorg) yline(0) level(95)
 
  margins, dydx(gender) at(tenure =(0 (1)12) ) 
 marginsplot, yline(0) level(95)
