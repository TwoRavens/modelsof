*******************************************************
*Replication DoFile for "The Dynamics of Mass Killings"


*please install the Ben Jann's "estout"-package to run this file
*Jann, Ben (2005): Making regression tables from stored estimates. The Stata 
*Journal 5(3): 288-308.
*Jann, Ben (2007): Making regression tables simplified. The Stata Journal 
*7(2): 227-244. 



cd "-your working directory here-"

set more off

set matsize 799

use bosnia_final9.dta,clear

eststo clear

sort stataweek

tsset stataweek, weekly


*******
**ARIMA


**massacre logic
eststo: quietly arima logsmwt logmswt L.logmswt, ar(1) ma(1)
eststo: quietly arima logmswt logsmwt L.logsmwt, ar(1) noconst

**military logic
eststo: quietly arima logsmwt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1) ma(1) 
eststo: quietly arima logmswt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1) noconst

esttab , b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("international logic/including talks")   label 
*esttab using Tabelle1.rtf, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("massacre and military logic") rtf onecell compress nogaps label
eststo clear



**international logic part1
eststo: quietly arima logsmwt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1) ma(1) 
eststo: quietly arima logmswt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, arima(1,0,1) sarima(1,0,0,12) noconst

**international logic part3 (only agreements)
eststo: quietly arima logsmwt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) ma(1) 
eststo: quietly arima logmswt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1 4) noconst

esttab , b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("international logic/including talks")   label 
*esttab using Tabelle2.rtf, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("international logic")  rtf onecell compress nogaps label
eststo clear




*****
**VAR




**full modell (international logic as exogenous variables)
rename logsmwt Serb_OSV
rename logmswt Bosniac_OSV

eststo: quietly var Serb_OSV Bosniac_OSV  battle terrwinms terrwinsm, exog(usaser_agree russer_agree usabos_agree unobos_agree unsanctions uncondem untribunal ununprofor) lag(1/4)
vargranger
irf set VAR, replace
irf create VAR, replace

irf cgraph (VAR Serb_OSV Bosniac_OSV  irf) (VAR Bosniac_OSV Serb_OSV  irf), level(90) cols(1)

irf drop VAR


*esttab using TabelleC1.csv, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("VAR: international logic")  scsv nogaps label
eststo clear

rename Serb_OSV logsmwt 
rename Bosniac_OSV logmswt 









**********
**appendix


***PART A

*descriptive statistics:
sum logsmwt logmswt logsmwd logmswd battle terrwinsm terrwinms usaser_talks eecser_talks unoser_talks russer_talks usaser_agree eecser_agree unoser_agree russer_agree usabos_talks eecbos_talks unobos_talks rusbos_talks usabos_agree eecbos_agree unobos_agree rusbos_agree dumnato unsanctions uncondem untribunal ununprofor




***PART B


***Additional Tests

**international logic part3 (consultations/agreements)
eststo: quietly arima logsmwt usaser_talks eecser_talks unoser_talks russer_talks usaser_agree eecser_agree unoser_agree russer_agree usabos_talks eecbos_talks unobos_talks rusbos_talks usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) ma(1) 
eststo: quietly arima logmswt usaser_talks eecser_talks unoser_talks russer_talks usaser_agree eecser_agree unoser_agree russer_agree usabos_talks eecbos_talks unobos_talks rusbos_talks usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) noconst

esttab , b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("international logic/including talks")   label 
eststo clear



**testing significant variables in one model
eststo: quietly arima logsmwt logmswt L.terrwinsm L.untribunal L.ununprofor unoser_agree russer_agree eecser_talks, ar(1) ma(1) 
eststo: quietly arima logmswt logsmwt L.logsmwt battle terrwinms L.terrwinms terrwinsm eecser_talks usaser_agree usabos_talks eecbos_talks, ar(1) noconst

esttab , b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("all significant variables")   label 
eststo clear




***testing all models with only killed victims

**massacre logic
eststo: quietly arima logsmwd logmswd L.logmswd, ar(1 3)
eststo: quietly arima logmswd logsmwd L.logsmwd, ar(1) sarima(1,0,0,12) noconst

**military logic
eststo: quietly arima logsmwd battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 2 7) 
eststo: quietly arima logmswd battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 6) sarima(1,0,0,12) noconst

esttab , b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 1, but only killed victims")  label 
eststo clear



**international logic part1
eststo: quietly arima logsmwd L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1 2)
eststo: quietly arima logmswd L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, arima(1,1,1) sarima(1,0,0,12) noconst

**international logic part3 (only agreements)
eststo: quietly arima logsmwd usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1 2) 
eststo: quietly arima logmswd usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) noconst

esttab , b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 2, but only killed victims")  label 
eststo clear


**Justifying ARMA-Term

*stationarity
dfuller logsmwt
dfuller logmswt
pperron logsmwt
pperron logmswt

*choice of lags:
*table 1 model 1
quietly arima logsmwt logmswt L.logmswt
predict r, res
ac r, saving(a) 
pac r, saving(b)
graph combine a.gph b.gph, col(1)
erase a.gph
erase b.gph
drop r
eststo: quietly arima logsmwt logmswt L.logmswt, ar(1)
eststo: quietly arima logsmwt logmswt L.logmswt, ar(1 2)
eststo: quietly arima logsmwt logmswt L.logmswt, ar(1 3)
eststo: quietly arima logsmwt logmswt L.logmswt, ar(1 2 3)
eststo: quietly arima logsmwt logmswt L.logmswt, ar(1) ma(1)
eststo: quietly arima logsmwt logmswt L.logmswt, ar(1 3) ma(1)
esttab, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 1 model 1")  label 
eststo clear

*table 1 model 2
quietly arima logmswt logsmwt L.logsmwt
predict r, res
ac r, saving(a) 
pac r, saving(b)
graph combine a.gph b.gph, col(1)
erase a.gph
erase b.gph
drop r
eststo: quietly arima logmswt logsmwt L.logsmwt, ar(1) noconst
eststo: quietly arima logmswt logsmwt L.logsmwt, ar(1) sarima(1,0,0,12) noconst
eststo: quietly arima logmswt logsmwt L.logsmwt, ma(1) noconst
eststo: quietly arima logmswt logsmwt L.logsmwt, ma(1) sarima(1,0,0,12) noconst
eststo: quietly arima logmswt logsmwt L.logsmwt, ar(1 4) noconst
eststo: quietly arima logmswt logsmwt L.logsmwt, ar(1 4) sarima(1,0,0,12) noconst
esttab, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 1 model 2")  label 
eststo clear

*table 1 model 3
quietly arima logsmwt battle terrwinms L.terrwinms terrwinsm L.terrwinsm
predict r, res
ac r, saving(a) 
pac r, saving(b)
graph combine a.gph b.gph, col(1)
erase a.gph
erase b.gph
drop r
eststo: quietly arima logsmwt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1) 
eststo: quietly arima logsmwt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 2) 
eststo: quietly arima logsmwt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 2 6) 
eststo: quietly arima logsmwt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1) ma(1) 
eststo: quietly arima logsmwt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 2) ma(1)
eststo: quietly arima logsmwt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 2 6) ma(1)
esttab, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 1 model 3")  label 
eststo clear

*table 1 model 4
quietly arima logmswt battle terrwinms L.terrwinms terrwinsm L.terrwinsm
predict r, res
ac r, saving(a) 
pac r, saving(b)
graph combine a.gph b.gph, col(1)
erase a.gph
erase b.gph
drop r
eststo: quietly arima logmswt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1) noconst
eststo: quietly arima logmswt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 2) noconst
eststo: quietly arima logmswt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 4) noconst
eststo: quietly arima logmswt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ma(1) noconst
eststo: quietly arima logmswt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1) ma(1) noconst
eststo: quietly arima logmswt battle terrwinms L.terrwinms terrwinsm L.terrwinsm, ar(1 2) ma(1) noconst
esttab, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 1 model 4")  label 
eststo clear

*table 2 model 1
quietly arima logsmwt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor
predict r, res
ac r, saving(a) 
pac r, saving(b)
graph combine a.gph b.gph, col(1)
erase a.gph
erase b.gph
drop r
eststo: quietly arima logsmwt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1) 
eststo: quietly arima logsmwt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1 2) 
eststo: quietly arima logsmwt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1 2 3) 
eststo: quietly arima logsmwt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ma(1) 
eststo: quietly arima logsmwt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1) ma(1) 
eststo: quietly arima logsmwt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1 2) ma(1) 
esttab, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 2 model 1")  label 
eststo clear

*table 2 model 2
quietly arima logmswt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor
predict r, res
ac r, saving(a) 
pac r, saving(b)
graph combine a.gph b.gph, col(1)
erase a.gph
erase b.gph
drop r
eststo: quietly arima logmswt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1) noconst
eststo: quietly arima logmswt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1) sarima(1,0,0,12) noconst
eststo: quietly arima logmswt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1 2) noconst
eststo: quietly arima logmswt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1 2) sarima(1,0,0,12) noconst
eststo: quietly arima logmswt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ma(1) sarima(1,0,0,12) noconst
eststo: quietly arima logmswt L.dumnato L.unsanctions L.uncondem L.untribunal L.ununprofor, ar(1) ma(1) sarima(1,0,0,12) noconst
esttab, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 2 model 2")  label 
eststo clear

*table 2 model 3
quietly arima logsmwt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree
predict r, res
ac r, saving(a) 
pac r, saving(b)
graph combine a.gph b.gph, col(1)
erase a.gph
erase b.gph
drop r
eststo: quietly arima logsmwt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) 
eststo: quietly arima logsmwt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1 2) 
eststo: quietly arima logsmwt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1 2 3) 
eststo: quietly arima logsmwt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ma(1) 
eststo: quietly arima logsmwt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) ma(1) 
eststo: quietly arima logsmwt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1 2) ma(1) 
esttab, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 2 model 3")  label 
eststo clear

*table 2 model 4
quietly arima logmswt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree
predict r, res
ac r, saving(a) 
pac r, saving(b)
graph combine a.gph b.gph, col(1)
erase a.gph
erase b.gph
drop r
eststo: quietly arima logmswt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) noconst
eststo: quietly arima logmswt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) sarima(1,0,0,12) noconst
eststo: quietly arima logmswt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1 4) noconst
eststo: quietly arima logmswt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1 4) sarima(1,0,0,12) noconst
eststo: quietly arima logmswt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ma(1) sarima(1,0,0,12) noconst
eststo: quietly arima logmswt usaser_agree eecser_agree unoser_agree russer_agree usabos_agree eecbos_agree unobos_agree rusbos_agree, ar(1) ma(1) sarima(1,0,0,12) noconst
esttab, b(3) star(* 0.1 ** 0.05 *** 0.01) scalars(ll aic bic) title("table 2 model 4")  label 
eststo clear



***PART C

dfuller battle
pperron battle
dfuller terrwinms
pperron terrwinms
dfuller terrwinsm
pperron terrwinsm

varsoc logsmwt logmswt  battle terrwinms terrwinsm, exog(usaser_agree russer_agree usabos_agree unobos_agree unsanctions uncondem untribunal ununprofor)
varsoc logsmwt logmswt  battle terrwinms terrwinsm

***with exogenous variables
**VAR(1)
quietly var logsmwt logmswt  battle terrwinms terrwinsm, exog(usaser_agree russer_agree usabos_agree unobos_agree unsanctions uncondem untribunal ununprofor) lag(1)

*VAR(1) stability condition
varstable
varlmar
irf set AppendixC, replace
irf create AppendixC, replace

irf graph irf, level(90) response(logsmwt) impulse(terrwinsm) saving(1a)

irf graph irf, level(90) response(logmswt) impulse(logsmwt) saving(1b)
irf graph irf, level(90) response(logmswt) impulse(battle) saving(1c)
irf graph irf, level(90) response(logmswt) impulse(terrwinsm) saving(1d)


irf graph cirf, level(90) response(logsmwt) impulse(logsmwt) saving(1e)

irf graph cirf, level(90) response(logmswt) impulse(logmswt) saving(1f)

irf drop AppendixC

*VAR(1) granger causality 
vargranger

**VAR(2)
quietly var logsmwt logmswt  battle terrwinms terrwinsm, exog(usaser_agree russer_agree usabos_agree unobos_agree unsanctions uncondem untribunal ununprofor) lag(1/2)

*VAR(2) stability condition
varstable
varlmar
irf set AppendixC, replace
irf create AppendixC, replace

irf graph irf, level(90) response(logsmwt) impulse(terrwinsm) saving(2a)

irf graph irf, level(90) response(logmswt) impulse(logsmwt) saving(2b)
irf graph irf, level(90) response(logmswt) impulse(battle) saving(2c)
irf graph irf, level(90) response(logmswt) impulse(terrwinsm) saving(2d)


irf graph cirf, level(90) response(logsmwt) impulse(logsmwt) saving(2e)

irf graph cirf, level(90) response(logmswt) impulse(logmswt) saving(2f)

irf drop AppendixC

*VAR(2) granger causality 
vargranger

**VAR(4)
quietly var logsmwt logmswt  battle terrwinms terrwinsm, exog(usaser_agree russer_agree usabos_agree unobos_agree unsanctions uncondem untribunal ununprofor) lag(1/4) 

*VAR(4) stability condition
varstable
varlmar
irf set AppendixC, replace
irf create AppendixC, replace

irf graph irf, level(90) response(logsmwt) impulse(terrwinsm) saving(4a)

irf graph irf, level(90) response(logmswt) impulse(logsmwt) saving(4b)
irf graph irf, level(90) response(logmswt) impulse(battle) saving(4c)
irf graph irf, level(90) response(logmswt) impulse(terrwinsm) saving(4d)


irf graph cirf, level(90) response(logsmwt) impulse(logsmwt) saving(4e)

irf graph cirf, level(90) response(logmswt) impulse(logmswt) saving(4f)

irf drop AppendixC

*VAR(4) granger causality 
vargranger


 graph combine 1a.gph 2a.gph , col(1)
 graph combine 1b.gph 2b.gph , col(1)
 graph combine 1c.gph 2c.gph , col(1)
 graph combine 1d.gph 2d.gph , col(1)

local lag "1 2 4"
local graph "a b c d e f"
foreach i of local lag {
foreach j of local graph {
erase `i'`j'.gph
}
}

***without exogenous variables
**VAR(1)
quietly var logsmwt logmswt  battle terrwinms terrwinsm, lag(1)
varstable
varlmar
irf set AppendixC, replace
irf create AppendixC, replace

irf graph irf, level(90) response(logsmwt) impulse(terrwinsm) saving(1a)

irf graph irf, level(90) response(logmswt) impulse(logsmwt) saving(1b)
irf graph irf, level(90) response(logmswt) impulse(battle) saving(1c)
irf graph irf, level(90) response(logmswt) impulse(terrwinsm) saving(1d)


irf graph cirf, level(90) response(logsmwt) impulse(logsmwt) saving(1e)

irf graph cirf, level(90) response(logmswt) impulse(logmswt) saving(1f)

irf drop AppendixC

*VAR(1) granger causality 
vargranger

**VAR(4)
quietly var logsmwt logmswt  battle terrwinms terrwinsm, lag(1/4) 
varstable
varlmar
irf set AppendixC, replace
irf create AppendixC, replace

irf graph irf, level(90) response(logsmwt) impulse(terrwinsm) saving(4a)

irf graph irf, level(90) response(logmswt) impulse(logsmwt) saving(4b)
irf graph irf, level(90) response(logmswt) impulse(battle) saving(4c)
irf graph irf, level(90) response(logmswt) impulse(terrwinsm) saving(4d)


irf graph cirf, level(90) response(logsmwt) impulse(logsmwt) saving(4e)

irf graph cirf, level(90) response(logmswt) impulse(logmswt) saving(4f)

irf drop AppendixC

*VAR(4) granger causality 
vargranger


 graph combine 1a.gph 4a.gph, col(1)
 graph combine 1b.gph 4b.gph, col(1)
 graph combine 1c.gph 4c.gph, col(1)
 graph combine 1d.gph 4d.gph, col(1)
 graph combine 1e.gph 4e.gph, col(1)
 graph combine 1f.gph 4f.gph, col(1)

local lag "1 4"
local graph "a b c d e f"
foreach i of local lag {
foreach j of local graph {
erase `i'`j'.gph
}
}

