******************************************
*** Attacks Ads - Ken Miller *************
*** 10. Cross Section File Conversion ****
******************************************


clear
set more off
set scheme lean1

* The three previous files: 1-2010 House and Senate, 2-2012 House, and 3-2012 Senate were exported as excel files
* In excel opposing advertising and attack volumes were calculated by summing those totals from the rows of the opponents
* After this was done, all rows were appended in excel to create the Advertising.xlsx file

import excel "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Advertising.xlsx", sheet("data") firstrow

* folding R uncontested Senate races into Safe R
recode competroth 0=1

* Flip scale for D's to create a Safe-Hopeless scale
gen rothchance=competroth
recode rothchance 1=9 2=8 3=7 4=6 6=4 7=3 8=2 9=1 if party==1

* AK 2010
recode rothchance 9=7 if id==3
recode rothchance 1=5 if id==4
recode rothchance 1=5 if id==5
* FL 2010
recode rothchance 9=7 if id==18
recode rothchance 2=4 if id==19
recode rothchance 2=6 if id==20

* ME in 2012
recode rothchance 7=8 if id==90

gen rothtight=rothchance
recode rothtight 9=1 8=2 7=3 6=4

* Value Labels
label define roth 1 "1.Safe R" 2 "2.Favored R" 3 "3.Lean R" 4 "4.Tilt R" ///
                  5 "5.Toss Up" 6 "6.Tilt D" 7 "7.Lean D" 8 "8.Favored D" 9 "9.Safe D" 
label define rodds 1 "1.Safe" 2 "2.Favored" 3 "3.Leaning Towards" 4 "4.Tilting Towards"  ///
                   5 "5.Toss Up" 6 "6.Tilting Away" 7 "7.Leaning Away" 8 "8.Unlikely" 9 "9.Hopeless"
label define rclose 1 "1.Non-Competitive" 2 "2.Less Competitive" 3 "3.Competitive" 4 "4.Tilting" 5 "5.Toss Up"
label define pty 1 "Democrat" 2 "Republican" 3 "Independent" 
label define status 1 "1.Incumbent" 2 "2.Challenger" 3 "3.Open" 
label define chamber 1 "1.Senate" 2 "2.House" 

label values competroth roth
label values rothchance rodds
label values rothtight rclose
label values party pty
label values ico status
label values race chamber

* Create Additional Ratio Variables
gen totalnegratio = totalnegvol/totalvol
gen cannegratio = cannegvol/canvol
egen outvol = rowtotal(parvol pagvol ibgvol scgvol)
egen outnegvol = rowtotal(parnegvol pagnegvol ibgnegvol scgnegvol)
gen outnegratio = outnegvol/outvol
gen oppnegratio = oppnegvol/canvol
gen supportnegratio = outnegvol/canvol
gen oppperratio = oppper/canvol
gen canperatk = canper/cannegvol
gen canperpct = canper/canvol
gen parperatk = parper/parnegvol
gen parperpct = parper/parvol
gen pagperatk = pagper/pagnegvol
gen pagperpct = pagper/pagvol
gen ibgperatk = ibgper/ibgnegvol
gen ibgperpct = ibgper/ibgvol
gen scgperatk = scgper/scgnegvol
gen scgperpct = scgper/scgvol
egen outpervol = rowtotal(parper pagper ibgper scgper)
gen supportperratio = outpervol/canvol
gen outpolvol = outnegvol - outpervol
gen supportpolratio = outpolvol/canvol

*** SAVE OUT THE FILE ***
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/advertising.dta"
