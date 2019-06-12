 cd "C:\Users\murdiea\Dropbox\Quackenbush 2012 Project\RR ouput"
use "C:\Users\murdiea\Dropbox\Quackenbush 2012 Project\Murdie and Quackenbush replication files\Counterinsurgency Outcomes.dta", replace 

*original models in paper (just to double check)

logit winnodraw numberofinsurgenciesend20 numberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
outreg2 using Table3 , replace word label bdec(5)

logit winnodraw numberofinsurgenciesend20 numberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate numlang if yearbg>=1945, cluster(ccode)
outreg2 using Table3 , append word label bdec(5)

logit winnodraw dictnumberofinsurgenciesend20 dictnumberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
outreg2 using Table3 , append word label bdec(5)

logit winnodraw dictnumberofinsurgenciesend20 dictnumberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate numlang if yearbg>=1945, cluster(ccode)
outreg2 using Table3 , append word label bdec(5)


logit winnodraw numberofinsurgenciesendwin20 numberofwarsendwin20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
outreg2 using Table4 , replace word label bdec(5)

logit winnodraw numberofinsurgenciesendwin20 numberofwarsendwin20  treat mech support occ  lelev ldis lcinc nwstate numlang if yearbg>=1945, cluster(ccode)
outreg2 using Table4 , append word label bdec(5)

logit winnodraw dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20  treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
outreg2 using Table4 , append word label bdec(5)

logit winnodraw dictnumberofinsurgenciesendwin20 dictnumberofwarsendwin20  treat mech support occ  lelev ldis lcinc nwstate numlang if yearbg>=1945, cluster(ccode)
outreg2 using Table4 , append word label bdec(5)


logit winnodraw numberofinsurgenciesend20 numberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
sum  winnodraw numberofinsurgenciesend20 numberofwarsend20 numberofinsurgenciesendwin20 numberofwarsendwin20 treat mech support occ  lelev ldis lcinc nwstate coldwar if e(sample)

tab winnodraw dictnumberofwarsend20 if e(sample)
tab winnodraw dictnumberofwarsendwin20 if e(sample)


*now, start 2-30 models

*ok - this is the way to do this - just now have to make sure to save all results

cpr numberofinsurgenciesend2 numberofinsurgenciesend3 numberofinsurgenciesend4 numberofinsurgenciesend5 numberofinsurgenciesend6 ///
	numberofinsurgenciesend7   numberofinsurgenciesend8 numberofinsurgenciesend9 numberofinsurgenciesend10 numberofinsurgenciesend11 numberofinsurgenciesend12 numberofinsurgenciesend13 ///
	numberofinsurgenciesend14 numberofinsurgenciesend15 numberofinsurgenciesend16 numberofinsurgenciesend17  numberofinsurgenciesend18  numberofinsurgenciesend19  numberofinsurgenciesend20 ///
	numberofinsurgenciesend21 numberofinsurgenciesend22 numberofinsurgenciesend23 numberofinsurgenciesend24 numberofinsurgenciesend25 numberofinsurgenciesend26  numberofinsurgenciesend27 ///
	numberofinsurgenciesend28  numberofinsurgenciesend29  numberofinsurgenciesend30 \ numberofwarsend2 numberofwarsend3 numberofwarsend4 numberofwarsend5 numberofwarsend6 ///
	numberofwarsend7 numberofwarsend8 numberofwarsend9 numberofwarsend10 numberofwarsend11 numberofwarsend12 numberofwarsend13 numberofwarsend14 numberofwarsend15 numberofwarsend16 numberofwarsend17 numberofwarsend18 ///
	numberofwarsend19 numberofwarsend20 numberofwarsend21 numberofwarsend22 numberofwarsend23 numberofwarsend24 numberofwarsend25 numberofwarsend26 numberofwarsend27 ///
	numberofwarsend28 numberofwarsend29 numberofwarsend30: logit  winnodraw @1 @2 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)



cpr numberofinsurgenciesendwin2 numberofinsurgenciesendwin3 numberofinsurgenciesendwin4 numberofinsurgenciesendwin5 numberofinsurgenciesendwin6 ///
	numberofinsurgenciesendwin7   numberofinsurgenciesendwin8 numberofinsurgenciesendwin9 numberofinsurgenciesendwin10 numberofinsurgenciesendwin11 numberofinsurgenciesendwin12 numberofinsurgenciesendwin13 ///
	numberofinsurgenciesendwin14 numberofinsurgenciesendwin15 numberofinsurgenciesendwin16 numberofinsurgenciesendwin17  numberofinsurgenciesendwin18  numberofinsurgenciesendwin19  numberofinsurgenciesendwin20 ///
	numberofinsurgenciesendwin21 numberofinsurgenciesendwin22 numberofinsurgenciesendwin23 numberofinsurgenciesendwin24 numberofinsurgenciesendwin25 numberofinsurgenciesendwin26  numberofinsurgenciesendwin27 ///
	numberofinsurgenciesendwin28  numberofinsurgenciesendwin29  numberofinsurgenciesendwin30 \ numberofwarsendwin2 numberofwarsendwin3 numberofwarsendwin4 numberofwarsendwin5 numberofwarsendwin6 ///
	numberofwarsendwin7 numberofwarsendwin8 numberofwarsendwin9 numberofwarsendwin10 numberofwarsendwin11 numberofwarsendwin12 numberofwarsendwin13 numberofwarsendwin14 numberofwarsendwin15 numberofwarsendwin16 numberofwarsendwin17 numberofwarsendwin18 ///
	numberofwarsendwin19 numberofwarsendwin20 numberofwarsendwin21 numberofwarsendwin22 numberofwarsendwin23 numberofwarsendwin24 numberofwarsendwin25 numberofwarsendwin26 numberofwarsendwin27 ///
	numberofwarsendwin28 numberofwarsendwin29 numberofwarsendwin30: logit  winnodraw @1 @2 treat mech support occ  lelev ldis lcinc nwstate coldwar   , cluster(ccode)




*AUC 
logit winnodraw numberofinsurgenciesend20 numberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
*drop baselinesample xb1 
gen baselinesample =1 if e(sample)

logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend20 numberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesendwin20 numberofwarsendwin20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample xb1 xb2

gen baselinesample =1 if e(sample)

logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesendwin20 numberofwarsendwin20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary


*Add additional dummies - US, UK, France 

gen US=1 if ccode==2
replace US=0 if ccode!=2

gen UK =1 if ccode==200
replace UK=0 if ccode!=200

gen France =1 if ccode==220
replace France = 0 if ccode!=220

gen UKUSFrance =1  if ccode==2 | ccode==200 | ccode==220
replace UKUSFrance =0 if ccode!=2 & ccode!=200 & ccode!=220


cpr US UK France UKUSFrance: logit winnodraw @1 numberofinsurgenciesend20 numberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
outreg2 using TableR5 , replace word label bdec(5)

cpr US UK France UKUSFrance: logit winnodraw @1 numberofinsurgenciesend20  numberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate numlang if yearbg>=1945, cluster(ccode)
outreg2 using TableR5 , append word label bdec(5)

cpr US UK France UKUSFrance:  logit winnodraw @1 dictnumberofinsurgenciesend20 dictnumberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
outreg2 using TableR5 , append word label bdec(5)

cpr US UK France UKUSFrance:  logit winnodraw  @1  dictnumberofinsurgenciesend20 dictnumberofwarsend20 treat mech support occ  lelev ldis lcinc nwstate numlang if yearbg>=1945, cluster(ccode)
outreg2 using TableR5 , append word label bdec(5)


cpr US UK France UKUSFrance:  logit winnodraw @1 numberofinsurgenciesendwin20 numberofwarsendwin20 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
outreg2 using TableR6 , replace word label bdec(5)

cpr US UK France UKUSFrance:  logit winnodraw @1 numberofinsurgenciesendwin20 numberofwarsendwin20  treat mech support occ  lelev ldis lcinc nwstate numlang if yearbg>=1945, cluster(ccode)
outreg2 using TableR6 , append word label bdec(5)

cpr US UK France UKUSFrance: logit winnodraw @1  dictnumberofinsurgenciesendwin20  dictnumberofwarsendwin20  treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
outreg2 using TableR6 , append word label bdec(5)

cpr US UK France UKUSFrance: logit winnodraw @1 dictnumberofinsurgenciesendwin20 dictnumberofwarsendwin20  treat mech support occ  lelev ldis lcinc nwstate numlang if yearbg>=1945, cluster(ccode)
outreg2 using TableR6 , append word label bdec(5)




*AUC for every stat sig one when war history is past 26 years  - *Note: this is for the original Lyall coding, in the updated coding, only 13 were stat sig 
logit winnodraw numberofinsurgenciesend8 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample  xb1 xb2

gen baselinesample =1 if e(sample)

logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend8 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend12 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend12 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary


logit winnodraw numberofinsurgenciesend13 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend13 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary


logit winnodraw numberofinsurgenciesend14 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend14 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary


logit winnodraw numberofinsurgenciesend15 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend15 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend16 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend16 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary


logit winnodraw numberofinsurgenciesend17 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend17 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary

logit winnodraw numberofinsurgenciesend18 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend18 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary

logit winnodraw numberofinsurgenciesend19 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend19 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend20 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend20 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary


logit winnodraw numberofinsurgenciesend21 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend21 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend22 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend22 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend23 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend23 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary




logit winnodraw numberofinsurgenciesend24 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend24 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend25 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend25 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary


logit winnodraw numberofinsurgenciesend26 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend26 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend27 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend27 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend28 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend28  numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary



logit winnodraw numberofinsurgenciesend29 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend29  numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary


logit winnodraw numberofinsurgenciesend30 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
drop baselinesample
gen baselinesample =1 if e(sample)
drop xb1 
drop xb2
logit winnodraw treat mech support occ  lelev ldis lcinc nwstate coldwar if baselinesample==1, cluster(ccode)
lroc, nograph
predict xb1, xb
logit winnodraw numberofinsurgenciesend30  numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
lroc, nograph
predict xb2, xb
roccomp winnodraw xb1 xb2, graph summary

*the results of these 21 specifications with Germany included as a dummy - *Note: this is for the original Lyall coding, in the updated coding, only 13 were stat sig 

gen GERMANY = 1 if ccode==255

replace GERMANY = 0 if ccode!=255 

logit winnodraw numberofinsurgenciesend8 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend12 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend13 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend14 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend15 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend16 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend17 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend18 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend19 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend20 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend21 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend22 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend23 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend24 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend25 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend26 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend27 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend28 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend29 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)
logit winnodraw numberofinsurgenciesend30 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY, cluster(ccode)

*take out ccode==255 

logit winnodraw numberofinsurgenciesend8 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend12 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend13 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend14 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend15 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend16 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend17 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend18 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend19 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend20 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend21 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend22 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend23 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend24 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend25 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend26 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend27 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend28 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend29 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)
logit winnodraw numberofinsurgenciesend30 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if ccode!=255, cluster(ccode)

*dummy out germany in 1944

gen GERMANY1944 = 1 if (ccode==255 & year==1944)

replace GERMANY1944 = 0 if GERMANY1944 != 1

logit winnodraw numberofinsurgenciesend8 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend12 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend13 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend14 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend15 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend16 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend17 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend18 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend19 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend20 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend21 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend22 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend23 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend24 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend25 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend26 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend27 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend28 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend29 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)
logit winnodraw numberofinsurgenciesend30 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar GERMANY1944, cluster(ccode)


*the results of these 21 specifications with a dichtomous indicator instead of counts

logit winnodraw dictnumberofinsurgenciesend8 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar, cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend12 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend13 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend14 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend15 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend16 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend17 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend18 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend19 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend20 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend21 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend22 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend23 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend24 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend25 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend26 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend27 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend28 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend29 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)
logit winnodraw dictnumberofinsurgenciesend30 dictnumberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar , cluster(ccode)

*the results of these 21 specifications only post 1945

logit winnodraw numberofinsurgenciesend8 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend12 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend13 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend14 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend15 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend16 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend17 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend18 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend19 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend20 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend21 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend22 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend23 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend24 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend25 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend26 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend27 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend28 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend29 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)
logit winnodraw numberofinsurgenciesend30 numberofwarsend26 treat mech support occ  lelev ldis lcinc nwstate coldwar if yearbg>=1945, cluster(ccode)






