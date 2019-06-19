*** Aufzeichung in Protokoll starten

clear
capture log close
log using "Z:\GWA4 - Cantoni\D_Ergebnisse\evs93_cantoni_20140812tables5_6.log", replace

***************************************************************************
***************************************************************************
*** Titel des Projekts: <Clueless? The impact of television on consumption behavior.>
*** Datengrundlage: <EVS 1993>
*** Dateiname des Programmcodes: evs93_cantoni_20140812tables5_6.do
*** erstellt: <2014/08/12> 
*** von: <Davide Cantoni> 
*** E-Mail: <cantoni@lmu.de> 
*** Tel.: <0176/21816773> 
*** Dateiname der Output-Files: <evs93_cantoni_20140812tables5_6.log> 
***			<evs93_cantoni_20140812tables5_6.txt>  
*** 
*** Grundriss des Programms: <Programm zur Untersuchung von 
*** Unterschieden im Konsumverhalten zwischen ehem. DDR-Regionen mit Zugang 
*** zu westlichen Fernsehsendern und solchen ohne.>
*** 
*** Verwendete Variablen: 
*** Originalvariablen: 	<mehrere>
*** 
*** Neu angelegte Variablen: <bula*: Bundesland-Dummy
***				berlinost: Dummy fuer Haushalte in Ostberlin
***				smallcity: Kleinstadt-Dummy
***				age: Ungefaehres Alter 
***				agesq: (Ungefaehres Alter)^2
***				single: Alleinstehend-Dummy
***				german: Dummy fuer deutsche Nationalitaet
***				female: Dummy fuer Frauen
***				employed: Dummy fuer Vollzeitbeschaeftigte 
***				retired: Dummy fuer Rentner 
***				onwelfare: Dummy fuer Sozialhilfeempfaenger 
***				treat: Neucodierung von ard_signalstaerke
***				netincome: Umbenennung von ef19
***				disposableincome: Umbenennung von ef21
***				weight: Umbenennung von ef66
***				ef100001-ef100014: Konsumausgaben, fuer die Werbungsinformationen bereitstehen
***				ef100015: Uebrige Konsumausgaben (ohne Werbung)
***				ef: Konsumausgaben (nach Umformung des Datensatzes)
***				logef: Logarithmus der Konsumausgaben (nach Umformung des Datensatzes)
***				log0ef: Logarithmus der Konsumausgaben+1 (nach Umformung des Datensatzes)>
***
*** Gewichtungsvariablen: <ef66: Umbenannt als "weight">
***
***************************************************************************
***************************************************************************

	
	**** Version festlegen

version 9.1

	**** Bildschirmausgabe steuern

set more off

	**** Arbeitsspeicher festlegen

set mem 750m

	**** Arbeitsverzeichnis festlegen

cd "Z:\GWA4 - Cantoni\D_Ergebnisse\"

	**** Datensatz vorbereiten

qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812preparedata.do"

	*** Aggregiertes Konsumverhalten 
	*** (aggregate consumption behavior - Table 5)

drop if berlinost==1

tab treat saving01

replace ln_dispincome=100*ln_dispincome
replace ln_ef100100=100*ln_ef100100
replace saving01=100*saving01

local controls "treat ln_dispincome age agesq kids single female german employed retired onwelfare bula* smallcity [w=weight]"

reg ln_dispincome treat age agesq kids single female german employed retired onwelfare bula* smallcity [w=weight], robust cluster(muni)
	outreg2 using evs93_cantoni_20140812tables5_6, br dec(4) ctitle("`e(depvar)', , Bula FE, all controls, no EastBerlin") replace
reg ln_ef100100 `controls', robust cluster(muni)
	outreg2 using evs93_cantoni_20140812tables5_6, br dec(4) ctitle("`e(depvar)', , Bula FE, all controls, no EastBerlin") 
reg saving01 `controls', robust cluster(muni)
	outreg2 using evs93_cantoni_20140812tables5_6, br dec(4) ctitle("`e(depvar)', , Bula FE, all controls, no EastBerlin") 

	*** Kreditaufnahme
	*** (credit taking behavior)

tab treat int_conscredit01 
tab treat int_overdraft01

replace int_conscredit01=100*int_conscredit01
replace int_overdraft01=100*int_overdraft01

reg int_conscredit01 `controls', robust cluster(muni)
	outreg2 using evs93_cantoni_20140812tables5_6, br dec(4) ctitle("`e(depvar)', , Bula FE, all controls, no EastBerlin") 
reg int_overdraft01 `controls', robust cluster(muni)
	outreg2 using evs93_cantoni_20140812tables5_6, br dec(4) ctitle("`e(depvar)', , Bula FE, all controls, no EastBerlin") 

log close
