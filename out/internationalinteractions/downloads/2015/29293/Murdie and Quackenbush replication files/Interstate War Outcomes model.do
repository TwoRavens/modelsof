 cd "C:\Users\murdiea\Dropbox\Quackenbush 2012 Project\RR ouput"
use "C:\Users\murdiea\Dropbox\Quackenbush 2012 Project\Murdie and Quackenbush replication files\Interstate War Outcomes.dta" , replace 

*original models in paper (just to double check)


*experience
logit win numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
outreg2 using Table1 , replace word label bdec(5)

logit win numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 &  endyear11>1945   , vce(cluster warnum)
outreg2 using Table1 , append word label bdec(5)

logit win  dictnumberofwarsend20 dictnumberofinsurgenciesend20  casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
outreg2 using Table1 , append word label bdec(5)

logit win dictnumberofwarsend20 dictnumberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945  , vce(cluster warnum)
outreg2 using Table1 , append word label bdec(5)


*wars won


logit win  numberofinsurgenciesendwin20 numberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
outreg2 using Table2 , replace word label bdec(5)

logit win numberofinsurgenciesendwin20 numberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945  , vce(cluster warnum)
outreg2 using Table2 , append word label bdec(5)

logit win dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
outreg2 using Table2 , append word label bdec(5)

logit win dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945   , vce(cluster warnum)
outreg2 using Table2 , append word label bdec(5)

*summary stats

logit win numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
sum  win numberofwarsend20 numberofinsurgenciesend20  numberofinsurgenciesendwin20 numberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if e(sample) 

tab win dictnumberofinsurgenciesend20 if e(sample) 
tab win dictnumberofinsurgenciesendwin20 if e(sample) 
***now, finally ready to start all of the additional models for years 1-30


*now, start 2-30 models

*ok - this is the way to do this - just now have to make sure to save all results

cpr numberofinsurgenciesend2 numberofinsurgenciesend3 numberofinsurgenciesend4 numberofinsurgenciesend5 numberofinsurgenciesend6 ///
	numberofinsurgenciesend7   numberofinsurgenciesend8 numberofinsurgenciesend9 numberofinsurgenciesend10 numberofinsurgenciesend11 numberofinsurgenciesend12 numberofinsurgenciesend13 ///
	numberofinsurgenciesend14 numberofinsurgenciesend15 numberofinsurgenciesend16 numberofinsurgenciesend17  numberofinsurgenciesend18  numberofinsurgenciesend19  numberofinsurgenciesend20 ///
	numberofinsurgenciesend21 numberofinsurgenciesend22 numberofinsurgenciesend23 numberofinsurgenciesend24 numberofinsurgenciesend25 numberofinsurgenciesend26  numberofinsurgenciesend27 ///
	numberofinsurgenciesend28  numberofinsurgenciesend29  numberofinsurgenciesend30 \ numberofwarsend2 numberofwarsend3 numberofwarsend4 numberofwarsend5 numberofwarsend6 ///
	numberofwarsend7 numberofwarsend8 numberofwarsend9 numberofwarsend10 numberofwarsend11 numberofwarsend12 numberofwarsend13 numberofwarsend14 numberofwarsend15 numberofwarsend16 numberofwarsend17 numberofwarsend18 ///
	numberofwarsend19 numberofwarsend20 numberofwarsend21 numberofwarsend22 numberofwarsend23 numberofwarsend24 numberofwarsend25 numberofwarsend26 numberofwarsend27 ///
	numberofwarsend28 numberofwarsend29 numberofwarsend30: logit win @1 @2 casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)




cpr numberofinsurgenciesendwin2 numberofinsurgenciesendwin3 numberofinsurgenciesendwin4 numberofinsurgenciesendwin5 numberofinsurgenciesendwin6 ///
	numberofinsurgenciesendwin7   numberofinsurgenciesendwin8 numberofinsurgenciesendwin9 numberofinsurgenciesendwin10 numberofinsurgenciesendwin11 numberofinsurgenciesendwin12 numberofinsurgenciesendwin13 ///
	numberofinsurgenciesendwin14 numberofinsurgenciesendwin15 numberofinsurgenciesendwin16 numberofinsurgenciesendwin17  numberofinsurgenciesendwin18  numberofinsurgenciesendwin19  numberofinsurgenciesendwin20 ///
	numberofinsurgenciesendwin21 numberofinsurgenciesendwin22 numberofinsurgenciesendwin23 numberofinsurgenciesendwin24 numberofinsurgenciesendwin25 numberofinsurgenciesendwin26  numberofinsurgenciesendwin27 ///
	numberofinsurgenciesendwin28  numberofinsurgenciesendwin29  numberofinsurgenciesendwin30 \ numberofwarsendwin2 numberofwarsendwin3 numberofwarsendwin4 numberofwarsendwin5 numberofwarsendwin6 ///
	numberofwarsendwin7 numberofwarsendwin8 numberofwarsendwin9 numberofwarsendwin10 numberofwarsendwin11 numberofwarsendwin12 numberofwarsendwin13 numberofwarsendwin14 numberofwarsendwin15 numberofwarsendwin16 numberofwarsendwin17 numberofwarsendwin18 ///
	numberofwarsendwin19 numberofwarsendwin20 numberofwarsendwin21 numberofwarsendwin22 numberofwarsendwin23 numberofwarsendwin24 numberofwarsendwin25 numberofwarsendwin26 numberofwarsendwin27 ///
	numberofwarsendwin28 numberofwarsendwin29 numberofwarsendwin30: logit win @1 @2 casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)



*AUC 

logit win  numberofinsurgenciesend20 numberofwarsend20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
*drop baselinesample xb1 xb2

gen baselinesample =1 if e(sample)

logit win     casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & baseline==1    , vce(cluster warnum)
lroc, nograph
predict xb1, xb
logit win  numberofinsurgenciesend20 numberofwarsend20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
lroc, nograph
predict xb2, xb
roccomp win xb1 xb2, graph summary



logit win  numberofinsurgenciesendwin20 numberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
drop baselinesample xb1 xb2
gen baselinesample =1 if e(sample)

logit win     casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & baseline==1    , vce(cluster warnum)
lroc, nograph
predict xb1, xb
logit win  numberofinsurgenciesendwin20 numberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
lroc, nograph
predict xb2, xb
roccomp win xb1 xb2, graph summary



*Add additional dummies - US, UK, France 

gen US=1 if ccode1==2
replace US=0 if ccode1!=2

gen UK =1 if ccode1==200
replace UK=0 if ccode1!=200

gen France =1 if ccode1==220
replace France = 0 if ccode1!=220

gen UKUSFrance =0  if ccode1==2 | ccode1==200 | ccode1==220
replace UKUSFrance =1 if ccode1!=2 & ccode1!=200 & ccode1!=220

cpr US UK France UKUSFrance: logit win @1 numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
outreg2 using TableR1 , replace word label bdec(5)

cpr US UK France UKUSFrance: logit win @1 numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 &  endyear11>1945   , vce(cluster warnum)
outreg2 using TableR1 , append word label bdec(5)

cpr US UK France UKUSFrance: logit win @1 dictnumberofwarsend20 dictnumberofinsurgenciesend20  casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
outreg2 using TableR1 , append word label bdec(5)

cpr US UK France UKUSFrance: logit win @1 dictnumberofwarsend20 dictnumberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945  , vce(cluster warnum)
outreg2 using TableR1 , append  word label bdec(5)

cpr US UK France UKUSFrance: logit win @1 numberofinsurgenciesendwin20 numberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
outreg2 using TableR2 , replace word label bdec(5)

cpr US UK France UKUSFrance: logit win @1  numberofinsurgenciesendwin20 numberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945  , vce(cluster warnum)
outreg2 using TableR2 , append word label bdec(5)

cpr US UK France UKUSFrance: logit win @1 dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster warnum)
outreg2 using TableR2 , append word label bdec(5)

cpr US UK France UKUSFrance: logit win @1 dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945   , vce(cluster warnum)
outreg2 using TableR2 , append word label bdec(5)

*And, try everything with cluster code on ccode1


logit win numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster ccode1)
outreg2 using TableR3 , replace word label bdec(5)

logit win numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 &  endyear11>1945   , vce(cluster ccode1)
outreg2 using TableR3 , append word label bdec(5)

logit win  dictnumberofwarsend20 dictnumberofinsurgenciesend20  casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster ccode1)
outreg2 using TableR3, append word label bdec(5)
logit win dictnumberofwarsend20 dictnumberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945  , vce(cluster ccode1)
outreg2 using TableR3 , append word label bdec(5)


*wars won


logit win  numberofinsurgenciesendwin20 numberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster ccode1)
outreg2 using TableR4 , replace word label bdec(5)

logit win numberofinsurgenciesendwin20 numberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945  , vce(cluster ccode1)
outreg2 using TableR4 , append word label bdec(5)

logit win dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2   if draw == 0    , vce(cluster ccode1)
outreg2 using TableR4 , append word label bdec(5)

logit win dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if draw == 0 & endyear11>1945   , vce(cluster ccode1)
outreg2 using TableR4 , append word label bdec(5)


*with draws included

*experience
logit win numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2     , vce(cluster warnum)
outreg2 using Tableca1 , replace word label bdec(5)

logit win numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if   endyear11>1945   , vce(cluster warnum)
outreg2 using Tableca1 , append word label bdec(5)

logit win  dictnumberofwarsend20 dictnumberofinsurgenciesend20  casratio adjrelpow initiator1 democ1 democ2      , vce(cluster warnum)
outreg2 using Tableca1 , append word label bdec(5)

logit win dictnumberofwarsend20 dictnumberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if endyear11>1945  , vce(cluster warnum)
outreg2 using Tableca1 , append word label bdec(5)


*wars won


logit win  numberofinsurgenciesendwin20 numberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2      , vce(cluster warnum)
outreg2 using Tableca2 , replace word label bdec(5)

logit win numberofinsurgenciesendwin20 numberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if  endyear11>1945  , vce(cluster warnum)
outreg2 using Tableca2 , append word label bdec(5)

logit win dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2      , vce(cluster warnum)
outreg2 using Tableca2 , append word label bdec(5)

logit win dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if   endyear11>1945   , vce(cluster warnum)
outreg2 using Tableca2 , append word label bdec(5)

*as an ordered logit 


*experience
ologit outcome numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2     , vce(cluster warnum)
outreg2 using Tableca3 , replace word label bdec(5)

ologit outcome numberofwarsend20 numberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if   endyear11>1945   , vce(cluster warnum)
outreg2 using Tableca3 , append word label bdec(5)

ologit outcome dictnumberofwarsend20 dictnumberofinsurgenciesend20  casratio adjrelpow initiator1 democ1 democ2      , vce(cluster warnum)
outreg2 using Tableca3 , append word label bdec(5)

ologit outcome dictnumberofwarsend20 dictnumberofinsurgenciesend20 casratio adjrelpow initiator1 democ1 democ2   if endyear11>1945  , vce(cluster warnum)
outreg2 using Tableca3 , append word label bdec(5)


*wars won


ologit outcome numberofinsurgenciesendwin20 numberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2      , vce(cluster warnum)
outreg2 using Tableca4 , replace word label bdec(5)

ologit outcome numberofinsurgenciesendwin20 numberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if  endyear11>1945  , vce(cluster warnum)
outreg2 using Tableca4 , append word label bdec(5)

ologit outcome dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20   casratio adjrelpow initiator1 democ1 democ2      , vce(cluster warnum)
outreg2 using Tableca4 , append word label bdec(5)

ologit outcome  dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20 casratio adjrelpow initiator1 democ1 democ2   if   endyear11>1945   , vce(cluster warnum)
outreg2 using Tableca4 , append word label bdec(5)
