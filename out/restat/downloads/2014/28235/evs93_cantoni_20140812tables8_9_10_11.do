*** Aufzeichung in Protokoll starten

clear
capture log close
log using "Z:\GWA4 - Cantoni\D_Ergebnisse\evs93_cantoni_20140812tables8_9_10_11.log", replace

***************************************************************************
***************************************************************************
*** Titel des Projekts: <Clueless? The impact of television on consumption behavior.>
*** Datengrundlage: <EVS 1993>
*** Dateiname des Programmcodes: evs93_cantoni_20140812tables8_9_10_11.do
*** erstellt: <2014/08/12> 
*** von: <Davide Cantoni> 
*** E-Mail: <cantoni@lmu.de> 
*** Tel.: <0176/21816773> 
*** Dateiname der Output-Files: <evs93_cantoni_20140812tables8_9_10_11.log> 
***			<evs93_cantoni_20140812tables8_9_10_11.txt>  
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
***				log0ef: Logarithmus der Konsumausgaben+1 (nach Umformung des Datensatzes)
***				good: ef-code (nach Umformung des Datensatzes)
***				totalexp: gesamte Konsumausgaben in den betrachteten Kategorien (nach Umformung des Datensatzes)
***				ef_shexp: relative Konsumausgaben in den betrachteten Kategorien (nach Umformung des Datensatzes)
***				minpd8089: Anzahl von Fernseh-Werbeminuten, 1980-1989
***				share8089: Anteil an Fernseh-Werbeminuten, 1980-1989
***				minXtre: Interaktionseffekt minpd8089*treat
***				shaXtre: Interaktionseffekt share8089*treat>
***
*** Gewichtungsvariablen: <ef66: Umbenannt als "weight"
***				budsh: Anteil von Konsumkategorie an Gesamtausgaben
***				wmix: Produkt von weight*budsh>
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
do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812reshape8089.do"

preserve
drop if berlinost==1

	*** Umschichtung von Konsumverhalten 
	*** (recomposition of consumption - Table 8)

local controls "[pw=wmix]"
local controlsfull "ln_dispincome age agesq kids single female german employed retired onwelfare bula* smallcity [pw=wmix]"

reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T8 C1, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster") replace

reg log0ef minpd8089 treat minXtre `controlsfull', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T8 C2, `e(depvar)', no FE, all controls, no East Berlin, w=mix, muni cluster")

reg log0ef share8089 treat shaXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T8 C3, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster")

local controls "[pw=weight]"

reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T8 C4, `e(depvar)', no FE, no controls, no East Berlin, w=sampling, muni cluster")

local controls "[pw=wmix]"

reg log0ef minpd8089 treatpr minXtrepr `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T8 C5, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster")


	*** Umschichtung von Konsumverhalten: Robustheit
	*** (recomposition of consumption: robustness - Table 9)

reg log0ef minpd8089 treat minXtre `controls', robust cluster(id)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br bdec(3) ctitle("T9 C1, `e(depvar)', no FE, no controls, no East Berlin, w=mix, hh cluster")

restore

reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br bdec(3) ctitle("T9 C2, `e(depvar)', no FE, no controls, with East Berlin, w=mix, muni cluster") 

clear
qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812preparedata.do"

preserve
drop treat
gen treat=(ard_signalstaerke__durchschn_>=-84.8)
qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812reshape8089.do"
drop if berlinost==1

local controls "[pw=wmix]"
reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T9 C3, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster, treat -84.8") 
restore

preserve
drop treat
gen treat=(ard_signalstaerke__durchschn_>=-82.8)
qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812reshape8089.do"
drop if berlinost==1

local controls "[pw=wmix]"
reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T9 C4, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster, treat -82.8") 
restore

preserve
drop treat
gen treat=(ard_signalstaerke__durchschn_>=-80.8)
qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812reshape8089.do"
drop if berlinost==1

local controls "[pw=wmix]"
reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T9 C5, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster, treat -80.8") 
restore


	*** Umschichtung von Konsumverhalten: Teil-Samples
	*** (recomposition of consumption: subsamples - Table 10)

preserve
keep if berlinost==0 & ard_signalstaerke__durchschn_>-116.8 & ard_signalstaerke__durchschn_<-56.8
qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812reshape8089.do"

local controls "[pw=wmix]"
reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T10 C1, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster, +/-30dB") 
restore

preserve
keep if berlinost==0 & ard_signalstaerke__durchschn_>-106.8 & ard_signalstaerke__durchschn_<-66.8
qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812reshape8089.do"

local controls "[pw=wmix]"
reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T10 C2, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster, +/-20dB") 
restore

preserve
keep if berlinost==0 & ard_signalstaerke__durchschn_>-96.8 & ard_signalstaerke__durchschn_<-76.8
qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812reshape8089.do"

local controls "[pw=wmix]"
reg log0ef minpd8089 treat minXtre `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T10 C3, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster, +/-10dB") 
restore


	*** Umschichtung von Konsumverhalten: Entfernung zur BRD
	*** (recomposition of consumption: distance to the west - Table 11)

qui do "Z:\GWA4 - Cantoni\C_Programm\evs93_cantoni_20140812reshape8089.do"
keep if berlinost==0 

replace distkm=distkm/100
replace minXdistkm=minXdistkm/100

local controls "[pw=wmix]"
reg log0ef minpd8089 treat minXtre distkm minXdistkm `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T11 C1, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster, distance km") 

preserve
keep if treat==1

reg log0ef minpd8089 distkm minXdistkm `controls', robust cluster(muni)
outreg2 using evs93_cantoni_20140812tables8_9_10_11, br dec(3) ctitle("T11 C2, `e(depvar)', no FE, no controls, no East Berlin, w=mix, muni cluster, treat only") 
restore










log close
