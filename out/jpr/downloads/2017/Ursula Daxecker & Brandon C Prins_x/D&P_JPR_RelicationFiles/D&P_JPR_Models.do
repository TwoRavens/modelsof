
*EMPIRICAL MODELS AND PREDICTIONS for JPR DAXECKER AND PRINS, 15-12-2015*

use "D&P_JPR_Data.dta"

tsset ucdpid yearmonth
*Inferential models, Table 1*
*Main model with FE*
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
eststo mod1
estat ic
*Main model pooled *
nbreg gedconfeventnew    l.allincidents   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011, cluster(ucdpid)
eststo mod2
estat ic
** 6-month moving average of piracy**
nbreg gedconfeventnew  i.ccode  allincidents6movavg  onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011
eststo mod3
estat ic
* pooled with 6-month moving average of piracy**
nbreg gedconfeventnew    allincidents6movavg  onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011, cluster(ucdpid)
eststo mod4
estat ic
*With GDP control*
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond  l12.lncgdpWB l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
eststo mod5
estat ic
*With Corruption control*
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond l12.corruption l12.lnpopWB  l.gedconfeventnew   i.year           if year<2011
eststo mod6
estat ic
*complex piracy events*
nbreg gedconfeventnew  i.ccode  l.seaincidents   onshoreoil diamond     l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011 
eststo mod7
estat ic
*Using only conflict events less than 50km from coast*
nbreg gedconfevent_50  i.ccode  l.allincidents   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfevent_50   i.year       if year<2011
eststo mod8
estat ic

esttab using "Tab1.rtf", drop (_cons) indicate("Country FE = *ccode*" "Year FE= *year*")  stats(aic bic) se  nocon title(Table 1: Event Count & OLS Regression of Maritime Piracy and Conflict Intensity) nonumbers label  b(%10.3f) r2 nonotes addnotes("Standard errors in parentheses.") replace 

*GDP and CORRUPTION IMPLICATIONS*
*Explain why we do not include GDP PC and corruption in all the models*
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond  l12.lncgdpWB  l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
predict Y1 if e(sample)
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond    l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
predict Y2 if e(sample)
sum Location yearmonth lncgdpWB lnpopWB rpe_gdp allincidents gedconfeventnew if Y1==. & Y2!=.
*lose 371 observations*
list Location yearmonth if Y1==.&Y2!=.
*lose Myanmar and Somalia*

drop Y1 Y2
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond  l12.corruption  l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
predict Y1 if e(sample)
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond    l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
predict Y2 if e(sample)
sum Location yearmonth if Y1==. & Y2!=.
*lose 303 observations*
list Location yearmonth corruption rpe_gdp allincidents gedconfeventnew if corruption==.&rpe_gdp!=.&allincidents!=.&e(sample)
*lose Algeria, Angola, Djibouti, Egypt, Myanmar Papua New Guinea, Philippines, and Sierra Leone Somalia Sudan*

drop Y1 Y2
*with both GDP PC and corruption in models, we lose even more cases*
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond  l12.corruption l12.lncgdpWB  l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
predict Y1 if e(sample)
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond    l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
predict Y2 if e(sample)
sum Location yearmonth if Y1==. & Y2!=.
*lose 630 cases*
list Location if Y1==. & Y2!=.
*lose Philippines, Myanmar, Sudan, Angola, Somalia, Papua New Guinea, Djibouti, Sierra Leone, Algeria, Egypt



*PREDICTION COMPARISONS*
*Out-of Sample Prediction Comparisons*
*replace missing 2013 values for capacity variable with lagged capacity*
gen rpe_gdpimp=rpe_gdp
lab var rpe_gdpimp "extractive capacity with 2013 imputation"
replace rpe_gdpimp = L12.rpe_gdpimp if rpe_gdpimp >= . 
gen rpe_gdpimpyl=l12.rpe_gdpimp
move rpe_gdpimp rpe_gdp

******Table II:Model 1 FE*
*FIXED EFFECTS MODELS*
*In sample*
*NBRM, Comparing model w/ piracy to lagged model*
*Calculate MSPE and Theil's U*
**FE model in sample with piracy**
nbreg gedconfeventnew    l.allincidents  i.ccode onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year    if year<2011& allincidents!=.
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year i.ccode if year<2011 & probhat!=.
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

**same model but without piracy**
nbreg gedconfeventnew    i.ccode onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year    if year<2011& allincidents!=.
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year i.ccode if year<2011 & probhat!=.
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

*Table II: Model 2*
*POOLED MODELS*
*In sample*
*Comparing model w/ piracy to lagged DV model*
*Calculate MSPE and Theil's U*

**clustered errors model in-sample with piracy and other resources**
nbreg gedconfeventnew    l.allincidents  onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year    if year<2011& allincidents!=. , cluster(ucdpid)
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year if year<2011 & probhat!=., cluster(ucdpid)
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

**same model but without piracy**
nbreg gedconfeventnew     onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year    if year<2011& allincidents!=. , cluster(ucdpid)
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year if year<2011 & probhat!=., cluster(ucdpid)
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive


**Table III: Model 1 FE**
**same model but out of sample with piracy**
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year>2010 & allincidents!=.
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.ccode i.year if year>2010 & probhat!=.
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

*same model but out of sample without piracy**
nbreg gedconfeventnew  i.ccode  onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year>2010 & allincidents!=.
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.ccode i.year if year>2010 & probhat!=.
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

*Table III: Model 2 Pooled**
**same model but out of sample with piracy**
nbreg gedconfeventnew    l.allincidents  onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year    if year>2010& allincidents!=. , cluster(ucdpid)
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year if year>2010 & probhat!=., cluster(ucdpid)
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

**same model but out of sample without piracy**
nbreg gedconfeventnew     onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year    if year>2010& allincidents!=. , cluster(ucdpid)
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year if year>2010 & probhat!=., cluster(ucdpid)
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive


**Revised Models for additional out of sample forecast comparisons using 6-month moving average piracy variable**
*Table IV: Model 3 FE**
**FE models models**
**out of sample with piracy**
nbreg gedconfeventnew  allincidents6movavg   onshoreoil diamond   l12.rpe_gdpimp l12.lnpopWB  l.gedconfeventnew   i.year       if year>2010 & allincidents!=.
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year i.ccode if year>2010 & probhat!=.
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

**same model but out of sample without piracy**
nbreg gedconfeventnew    onshoreoil diamond   l12.rpe_gdpimp l12.lnpopWB  l.gedconfeventnew   i.year       if year>2010 & allincidents!=.
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year i.ccode if year>2010 & probhat!=.
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

**Table IV: Model 4 Pooled**
**NBRM pooled with clustered errors**
**out of sample with piracy**
nbreg gedconfeventnew    allincidents6movavg   onshoreoil diamond   l12.rpe_gdpimp l12.lnpopWB  l.gedconfeventnew   i.year       if year>2010 & allincidents!=., cluster(ucdpid)
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year if year>2010 & probhat!=., cluster(ucdpid)
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive

*same model but out of sample without piracy**
nbreg gedconfeventnew     onshoreoil diamond   l12.rpe_gdpimp l12.lnpopWB  l.gedconfeventnew   i.year       if year>2010 & allincidents!=., cluster(ucdpid)
predict probhat if e(sample)
nbreg gedconfeventnew l.gedconfeventnew i.year if year>2010 & probhat!=., cluster(ucdpid)
predict Ynaive if e(sample)
preserve
gen suemod=(gedconfeventnew-probhat)^2
gen suenaiv=(gedconfeventnew-Ynaive)^2
egen ssuemod=total(suemod) if e(sample)
su ssuemod
local num=r(mean)
egen ssuenaiv=total(suenaiv) if e(sample)
 su ssuenaiv
local den=r(mean)
local U=sqrt(`num'/`den') 
display `U'
su suemod
local MSPE=r(mean)
display `MSPE'
restore
drop probhat Ynaive
**end of new stuff**




*Models for online appendix*
*Model 1*
*Without lagged DV*
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond  l12.rpe_gdp l12.lnpopWB     i.year           if year<2011
estat ic
*Model 2*
*6-month piracy Lag*
nbreg gedconfeventnew  i.ccode  l6.allincidents  onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011
estat ic
*Model 3*
*12-month piracy lag**
nbreg gedconfeventnew  i.ccode  l12.allincidents  onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011
estat ic
*Model 4*
*With Polity control*
nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond l12.polity  l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year           if year<2011
estat ic
*Model 5*
*Using Violent Piracy*
nbreg gedconfeventnew  i.ccode  l.violence   onshoreoil diamond  l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year           if year<2011
estat ic
*Model 6*
*Using Violent Piracy with 12 month lag*
nbreg gedconfeventnew  i.ccode  l12.violence   onshoreoil diamond  l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year           if year<2011
estat ic
**Model 7*
*Using 12nm Territorial Waters piracy**
nbreg gedconfeventnew  i.ccode  l12.allincidentsTW   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
estat ic
*Model 8*
*Using 200NM EEZ piracy*
nbreg gedconfeventnew  i.ccode  l12.allincidentsEEZ   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011
estat ic
*Model 9*
*Using 12nm Territorial waters and clustered errors*
nbreg gedconfeventnew    l12.allincidentsTW   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011, cluster(ucdpid)
estat ic
*Model 10*
*Using 200nm EEZs and clustered errors*
nbreg gedconfeventnew    l12.allincidentsEEZ   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011, cluster(ucdpid)
estat ic
*Model 11*
*Coastal conflicts only*
nbreg gedconfevent_50  i.ccode  l12.allincidents   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfevent_50   i.year       if year<2011
estat ic
*Model 12*
*6 month MA hijackings*
nbreg gedconfeventnew  i.ccode  l.hijack6movavg  onshoreoil diamond   l12.rpe_gdp l12.lnpopWB  l.gedconfeventnew   i.year       if year<2011
estat ic





