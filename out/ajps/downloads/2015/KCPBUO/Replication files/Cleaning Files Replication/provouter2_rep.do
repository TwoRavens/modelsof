* Province outer do-file
* This file generates village, subdistrict, district, and province-level 
* aggregates from individual census data from the 2000 Census for each province
* It is run by multfiles_rep.do to generate a nationwide dataset of Census
* aggregates. Replication 
* Yuhki Tajima
* Updated: 25 September 2012


*******************
**Generate ID Codes**
*******************

gen vilid=kdprop+kdkab+kdkec+kddesa
gen kecid=kdprop+kdkab+kdkec
gen kabid=kdprop+kdkab
gen prop=kdprop
destring prop kabid kecid vilid p03 p05b p07 p082 p10, replace
gen double villageid=vilid
drop vilid
rename p10 diplygm

preserve

**************************************************************************************
**************************************************************************************
* 
* This section makes village-level measures out of indiv data
* Outputs: popv popygmvil mdyredvil mnyredvil covyredvil sdyredvil theilyredvil
*
**************************************************************************************
**************************************************************************************

*************************
**Population at Village**
*************************
sort villageid
by villageid: gen popv=_N


**********************
**Generate Educ Vars**
**********************
**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort villageid
by villageid: gen popygmvil=_N
by villageid: egen mdyredvil=median(yrsedygm)
by villageid: egen mnyredvil=mean(yrsedygm)
by villageid: egen numobsyeym=count(yrsedygm)
drop if (popygmvil<=2 | numobsyeym<=2)

*****************************************
**Generate Vertical Inequality Measures**
*****************************************

*******
**COV**
*******

gen covyredcmvil=(yrsedygm-mnyredvil)^2
by villageid: egen covyredcmvil2=sum(covyredcmvil)
gen covyredvil=((covyredcmvil2/(popv-1))^.5)/mnyredvil

**********************
**STANDARD DEVIATION**
**********************

by villageid: egen sdyredvil=sd(yrsedygm)


*********
**THEIL**
*********

gen thyredcmvil=yrsedygm/mnyredvil*ln(yrsedygm/mnyredvil)
by villageid: egen thyredcmvilsum=total(thyredcmvil)
gen theilyredvil=thyredcmvilsum/popygmvil

by villageid: keep if _n==1

keep prop kabid kecid villageid popv popygmvil mdyredvil mnyredvil covyredvil sdyredvil theilyredvil

sort villageid
save indvil, replace

restore
preserve

**************************************************************************************
**************************************************************************************
* 
* This section makes village-level ethnic diversity measures out of individual data
* Outputs: theilethvil ethfractvil wgcovegvil gtheilegvil lgeg40vil
* 
**************************************************************************************
**************************************************************************************

sort villageid
merge villageid using indvil.dta


**************************************
**Population Ethnic Group at Village**
**************************************
sort villageid p082
by villageid p082: gen popethgvil=_N
by villageid p082: keep if _n==1

gen percethgvil=popethgvil/popv
gen pelnpevil=percethgvil*ln(1/percethgvil)
egen theilethvil=total(pelnpevil), by(villageid)

gen sqpevil=percethgvil^2
egen hethvil=total(sqpevil), by(villageid)
gen ethfractvil=1-hethvil

by villageid: gen numethgvil=_N
gen lgeg40vil=0
by villageid: egen mxegvil = max(percethgvil)
by villageid: replace lgeg40vil=1 if mxegvil>=.4

keep prop kabid kecid villageid p082 percethgvil popethgvil theilethvil ethfractvil lgeg40vil

sort villageid p082
save indegviltemp, replace

**********************
**Generate Educ Vars**
**********************
restore
preserve

sort villageid
merge villageid using indvil.dta


**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

sort villageid p082
drop _merge
merge villageid p082 using indegviltemp 
drop _merge
sort villageid
merge villageid using indvil, keep(mnyredvil)

keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort villageid p082
by villageid p082: egen mdyredegvil=median(yrsedygm)
by villageid p082: egen mnyredegvil=mean(yrsedygm)
by villageid p082: gen nymegvil=_N

by villageid p082: keep if _n==1

gen uwgcovegcmvil=(mnyredegvil-mnyredvil)^2
gen wgcovegcmvil=percethgvil*uwgcovegcmvil
by villageid: egen wgcovegcmvilsum=total(wgcovegcmvil)
gen wgcovegvil=(wgcovegcmvilsum^.5)/mnyredvil

gen gthegcmpvil=percethgvil*(mnyredegvil/mnyredvil)*ln(mnyredegvil/mnyredvil)
by villageid: egen gtheilegvil=total(gthegcmpvil)

by villageid: keep if _n==1

keep prop kabid kecid villageid theilethvil ethfractvil wgcovegvil gtheilegvil lgeg40vil

save indegvil, replace


restore
preserve

**************************************************************************************
**************************************************************************************
* 
* This section makes village-level religious diversity measures out of individual data
* Outputs: theilrelvil relfractvil wgcovrgvil gtheilrgvil lgrg40vil
* 
**************************************************************************************
**************************************************************************************

sort villageid
merge villageid using indvil.dta



*****************************************
**Population Religious Group at Village**
*****************************************
sort villageid p07
by villageid p07: gen poprelgvil=_N
by villageid p07: keep if _n==1

gen percrelgvil=poprelgvil/popv
gen pelnprvil=percrelgvil*ln(1/percrelgvil)
egen theilrelvil=total(pelnprvil), by(villageid)

gen sqprvil=percrelgvil^2
egen hrelvil=total(sqprvil), by(villageid)
gen relfractvil=1-hrelvil

by villageid: gen numrelgvil=_N
gen lgrg40vil=0
by villageid: egen mxrgvil = max(percrelgvil)
by villageid: replace lgrg40vil=1 if mxrgvil>=.4

keep prop kabid kecid villageid p07 percrelgvil poprelgvil theilrelvil relfractvil lgrg40vil

sort villageid p07
save indrgviltemp, replace

**********************
**Generate Educ Vars**
**********************
restore
preserve

sort villageid
merge villageid using indvil.dta

**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

sort villageid p07
drop _merge
merge villageid p07 using indrgviltemp 
drop _merge
sort villageid
merge villageid using indvil, keep(mnyredvil)


keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort villageid p07
by villageid p07: egen mdyredrgvil=median(yrsedygm)
by villageid p07: egen mnyredrgvil=mean(yrsedygm)
by villageid p07: gen nymrgvil=_N

by villageid p07: keep if _n==1

gen uwgcovrgcmvil=(mnyredrgvil-mnyredvil)^2
gen wgcovrgcmvil=percrelgvil*uwgcovrgcmvil
by villageid: egen wgcovrgcmvilsum=total(wgcovrgcmvil)
gen wgcovrgvil=(wgcovrgcmvilsum^.5)/mnyredvil

gen gthrgcmpvil=percrelgvil*(mnyredrgvil/mnyredvil)*ln(mnyredrgvil/mnyredvil)
by villageid: egen gtheilrgvil=total(gthrgcmpvil)

by villageid: keep if _n==1

keep prop kabid kecid villageid theilrelvil relfractvil wgcovrgvil gtheilrgvil lgrg40vil

save indrgvil, replace

restore
preserve


**************************************************************************************
**************************************************************************************
*
* This section makes sub-district-level measures out of indiv data
* Outputs: popsd popygmsd mdyredsd mnyredsd covyredsd sdyredsd theilyredsd giniyredsd
* 
**************************************************************************************
**************************************************************************************

******************************
**Population at Sub-District**
******************************
sort kecid
by kecid: gen popsd=_N


**********************
**Generate Educ Vars**
**********************
**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort kecid
by kecid: gen popygmsd=_N
by kecid: egen mdyredsd=median(yrsedygm)
by kecid: egen mnyredsd=mean(yrsedygm)
by kecid: egen numobsyeym=count(yrsedygm)
drop if (popygmsd<=2 | numobsyeym<=2)

*****************************************
**Generate Vertical Inequality Measures**
*****************************************

*******
**COV**
*******

gen covyredcmsd=(yrsedygm-mnyredsd)^2
by kecid: egen covyredcmsd2=total(covyredcmsd)
gen covyredsd=((covyredcmsd2/(popsd-1))^.5)/mnyredsd

**********************
**STANDARD DEVIATION**
**********************

by kecid: egen sdyredsd=sd(yrsedygm)
qui levels kecid, local(reg)
gen giniyredsd = .
foreach r of local reg {
	qui fastgini yrsedygm if kecid==`r'
	qui replace giniyredsd=r(gini) if kecid==`r'
}




*********
**THEIL**
*********

gen thyredcmsd=yrsedygm/mnyredsd*ln(yrsedygm/mnyredsd)
by kecid: egen thyredcmsdsum=total(thyredcmsd)
gen theilyredsd=thyredcmsdsum/popygmsd



by kecid: keep if _n==1

keep prop kabid kecid popsd popygmsd mdyredsd mnyredsd covyredsd sdyredsd theilyredsd giniyredsd

sort kecid
save indsd, replace

restore
preserve

**************************************************************************************
**************************************************************************************
*
* This section makes sub-district-level ethnic diversity measures out of individual data
* Outputs: theilethsd ethfractsd wgcovegsd gtheilegsd lgeg40sd ethclustsd
* 
**************************************************************************************
**************************************************************************************

sort villageid
merge villageid using indvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge



*******************************************
**Population Ethnic Group at Sub-District**
*******************************************
sort kecid p082
by kecid p082: gen popethgsd=_N
by kecid p082: keep if _n==1

gen percethgsd=popethgsd/popsd
gen pelnpesd=percethgsd*ln(1/percethgsd)
egen theilethsd=total(pelnpesd), by(kecid)

gen sqpesd=percethgsd^2
egen hethsd=total(sqpesd), by(kecid)
gen ethfractsd=1-hethsd

by kecid: gen numethgsd=_N
gen lgeg40sd=0
by kecid: egen mxegsd = max(percethgsd)
by kecid: replace lgeg40sd=1 if mxegsd>=.4

keep prop kabid kecid p082 percethgsd popethgsd theilethsd ethfractsd lgeg40sd

sort kecid p082
save indegsdtemp, replace

**********************
**Generate Educ Vars**
**********************
restore
preserve

sort villageid
merge villageid using indvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge

**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

sort kecid p082

merge kecid p082 using indegsdtemp 
drop _merge
sort kecid 
merge kecid using indsd, keep(mnyredsd)
drop _merge


keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort kecid p082
by kecid p082: egen mdyredegsd=median(yrsedygm)
by kecid p082: egen mnyredegsd=mean(yrsedygm)
by kecid p082: gen nymegsd=_N

by kecid p082: keep if _n==1

gen uwgcovegcmsd=(mnyredegsd-mnyredsd)^2
gen wgcovegcmsd=percethgsd*uwgcovegcmsd
by kecid: egen wgcovegcmsdsum=total(wgcovegcmsd)
gen wgcovegsd=(wgcovegcmsdsum^.5)/mnyredsd

gen gthegcmpsd=percethgsd*(mnyredegsd/mnyredsd)*ln(mnyredegsd/mnyredsd)
by kecid: egen gtheilegsd=total(gthegcmpsd)

by kecid: keep if _n==1

keep prop kabid kecid theilethsd ethfractsd wgcovegsd gtheilegsd lgeg40sd
sort kecid
save indegsdtemp, replace

drop _all
use indvil
sort villageid
merge villageid using indegvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge
sort kecid villageid
merge kecid using indegsdtemp
drop _merge
sort kecid

*******************************************************
**Ethnic clustering at the Village-Sub-District Level**
*******************************************************

gen dcpthesd=(popv/popsd)*(theilethsd-theilethvil)
by kecid: egen dcpthesdsum=total(dcpthesd)
gen ethclustsd=dcpthesdsum/theilethsd

keep prop kabid kecid theilethsd ethfractsd wgcovegsd gtheilegsd lgeg40sd ethclustsd

sort kecid
by kecid: keep if _n==1

save indegsd, replace

restore
preserve

**************************************************************************************
**************************************************************************************
*
* This section makes sub-district-level religious diversity measures out of individual data
* Outputs: theilrelsd relfractsd wgcovrgsd gtheilrgsd lgrg40sd relclustsd
* 
**************************************************************************************
**************************************************************************************

sort villageid
merge villageid using indvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge

**********************************************
**Population Religious Group at Sub-District**
**********************************************
sort kecid p07
by kecid p07: gen poprelgsd=_N
by kecid p07: keep if _n==1

gen percrelgsd=poprelgsd/popsd
gen pelnprsd=percrelgsd*ln(1/percrelgsd)
egen theilrelsd=total(pelnprsd), by(kecid)

gen sqprsd=percrelgsd^2
egen hrelsd=total(sqprsd), by(kecid)
gen relfractsd=1-hrelsd

by kecid: gen numrelgsd=_N
gen lgrg40sd=0
by kecid: egen mxrgsd = max(percrelgsd)
by kecid: replace lgrg40sd=1 if mxrgsd>=.4

keep prop kabid kecid p07 percrelgsd poprelgsd theilrelsd relfractsd lgrg40sd

sort kecid p07
save indrgsdtemp, replace

**********************
**Generate Educ Vars**
**********************
restore
preserve

sort villageid
merge villageid using indvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge

**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

sort kecid p07

merge kecid p07 using indrgsdtemp 
drop _merge
sort kecid 
merge kecid using indsd, keep(mnyredsd)
drop _merge



keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort kecid p07
by kecid p07: egen mdyredrgsd=median(yrsedygm)
by kecid p07: egen mnyredrgsd=mean(yrsedygm)
by kecid p07: gen nymrgsd=_N

by kecid p07: keep if _n==1

gen uwgcovrgcmsd=(mnyredrgsd-mnyredsd)^2
gen wgcovrgcmsd=percrelgsd*uwgcovrgcmsd
by kecid: egen wgcovrgcmsdsum=total(wgcovrgcmsd)
gen wgcovrgsd=(wgcovrgcmsdsum^.5)/mnyredsd

gen gthrgcmpsd=percrelgsd*(mnyredrgsd/mnyredsd)*ln(mnyredrgsd/mnyredsd)
by kecid: egen gtheilrgsd=total(gthrgcmpsd)

by kecid: keep if _n==1

keep prop kabid kecid theilrelsd relfractsd wgcovrgsd gtheilrgsd lgrg40sd
sort kecid
save indrgsdtemp, replace

drop _all
use indvil
sort villageid
merge villageid using indrgvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge
sort kecid villageid
merge kecid using indrgsdtemp
drop _merge
sort kecid

gen dcpthrsd=(popv/popsd)*(theilrelsd-theilrelvil)
by kecid: egen dcpthrsdsum=total(dcpthrsd)
gen relclustsd=dcpthrsdsum/theilrelsd

keep prop kabid kecid theilrelsd relfractsd wgcovrgsd gtheilrgsd lgrg40sd relclustsd

sort kecid
by kecid: keep if _n==1

save indrgsd, replace

restore
preserve

**************************************************************************************
**************************************************************************************
*
* This section takes village data and generates subdistrict variables
* Outputs: wgcovvilsd, gtheilvilsd
* 
**************************************************************************************
**************************************************************************************

drop _all

use indvil
sort kecid villageid
merge kecid using indsd
drop _merge
sort kecid villageid
gen uwgcovvilcmsd=(mnyredvil-mnyredsd)^2
gen wgcovvilcmsd=popv*uwgcovvilcmsd/popsd
by kecid: egen wgcovvilcmsdsum=total(wgcovvilcmsd)
gen wgcovvilsd=(wgcovvilcmsdsum^.5)/mnyredsd

gen gthvilcmpsd=(popv/popsd)*(mnyredvil/mnyredsd)*ln(mnyredvil/mnyredsd)
by kecid: egen gtheilvilsd=total(gthvilcmpsd)

by kecid: keep if _n==1

keep prop kabid kecid wgcovvilsd gtheilvilsd

save vilsd, replace

restore
preserve
**************************************************************************************
**************************************************************************************
* 
* This section makes district-level measures out of indiv data
* Outputs: popd popygmd mdyredd mnyredd covyredd sdyredd theilyredd giniyredd
* 
**************************************************************************************
**************************************************************************************

******************************
**Population at District**
******************************
sort kabid
by kabid: gen popd=_N
*by kabid: sum diplygm

**********************
**Generate Educ Vars**
**********************
**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort kabid
by kabid: gen popygmd=_N
by kabid: egen mdyredd=median(yrsedygm)
by kabid: egen mnyredd=mean(yrsedygm)
by kabid: egen numobsyeym=count(yrsedygm)
drop if (popygmd<=2 | numobsyeym<=2)

*****************************************
**Generate Vertical Inequality Measures**
*****************************************

*******
**COV**
*******

gen covyredcmd=(yrsedygm-mnyredd)^2
by kabid: egen covyredcmd2=total(covyredcmd)
gen covyredd=((covyredcmd2/(popd-1))^.5)/mnyredd

**********************
**STANDARD DEVIATION**
**********************

by kabid: egen sdyredd=sd(yrsedygm)

********
**GINI**
********

qui levels kabid, local(reg)
gen giniyredd = .
foreach r of local reg {
	qui fastgini yrsedygm if kabid==`r'
	qui replace giniyredd=r(gini) if kabid==`r'
}




*********
**THEIL**
*********

gen thyredcmd=yrsedygm/mnyredd*ln(yrsedygm/mnyredd)
by kabid: egen thyredcmdsum=total(thyredcmd)
gen theilyredd=thyredcmdsum/popygmd

by kabid: keep if _n==1

keep prop kabid popd popygmd mdyredd mnyredd covyredd sdyredd theilyredd giniyredd

sort kabid
save indd, replace

restore
preserve

**************************************************************************************
**************************************************************************************
*
* This section makes district-level ethnic diversity measures out of individual data
* Outputs: theilethd ethfractd wgcovegd gtheilegd lgeg40d ethclustvd ethclustsdd
* 
**************************************************************************************
**************************************************************************************

sort villageid
merge villageid using indvil
drop _merge

sort kabid kecid villageid
merge kabid using indd
drop _merge

***************************************
**Population Ethnic Group at District**
***************************************
sort kabid p082
by kabid p082: gen popethgd=_N
by kabid p082: keep if _n==1

gen percethgd=popethgd/popd
gen pelnped=percethgd*ln(1/percethgd)
egen theilethd=total(pelnped), by(kabid)

gen sqped=percethgd^2
egen hethd=total(sqped), by(kabid)
gen ethfractd=1-hethd

by kabid: gen numethgd=_N
gen lgeg40d=0
by kabid: egen mxegd = max(percethgd)
by kabid : replace lgeg40d=1 if mxegd>=.4

keep prop kabid p082 percethgd popethgd theilethd ethfractd lgeg40d

sort kabid p082
save indegdtemp, replace

**********************
**Generate Educ Vars**
**********************
restore
preserve

sort villageid
merge villageid using indvil
drop _merge

sort kabid kecid villageid
merge kabid using indd
drop _merge

**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

sort kabid p082

merge kabid p082 using indegdtemp 
drop _merge
sort kabid 
merge kabid using indd, keep(mnyredd)
drop _merge



keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort kabid p082
by kabid p082: egen mdyredegd=median(yrsedygm)
by kabid p082: egen mnyredegd=mean(yrsedygm)
by kabid p082: gen nymegd=_N

by kabid p082: keep if _n==1

gen uwgcovegcmd=(mnyredegd-mnyredd)^2
gen wgcovegcmd=percethgd*uwgcovegcmd
by kabid: egen wgcovegcmdsum=total(wgcovegcmd)
gen wgcovegd=(wgcovegcmdsum^.5)/mnyredd

gen gthegcmpd=percethgd*(mnyredegd/mnyredd)*ln(mnyredegd/mnyredd)
by kabid : egen gtheilegd=total(gthegcmpd)

by kabid: keep if _n==1

keep prop kabid theilethd ethfractd wgcovegd gtheilegd lgeg40d
sort kabid 
save indegdtemp, replace

drop _all
use indvil
sort villageid
merge villageid using indegvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge
sort kecid villageid
merge kecid using indegsdtemp
drop _merge
sort kabid villageid
merge kabid using indd
drop _merge
sort kabid villageid
merge kabid using indegdtemp
drop _merge
sort kabid

***********************************************
**ETHNIC CLUSTERING AT VILLAGE-DISTRICT LEVEL**
***********************************************


gen dcpthevd=(popv/popd)*(theilethd-theilethvil)
by kabid: egen dcpthevdsum=total(dcpthevd)
gen ethclustvd=dcpthevdsum/theilethd

gen dcpthesdd=(popsd/popd)*(theilethd-theilethsd)
by kabid: egen dcpthesddsum=total(dcpthesdd)
gen ethclustsdd=dcpthesddsum/theilethd


keep prop kabid theilethd ethfractd wgcovegd gtheilegd lgeg40d ethclustvd ethclustsdd

sort kabid 
by kabid: keep if _n==1

save indegd, replace

restore
preserve


**************************************************************************************
**************************************************************************************
*
* This section makes district-level religious diversity measures out of individual data
* Outputs: theilethd ethfractd wgcovegd gtheilegd lgeg40d ethclustvd ethclustsdd
* 
**************************************************************************************
**************************************************************************************

sort villageid
merge villageid using indvil
drop _merge

sort kabid kecid villageid
merge kabid using indd
drop _merge

******************************************
**Population Religious Group at District**
******************************************
sort kabid p07
by kabid p07: gen poprelgd=_N
by kabid p07: keep if _n==1

gen percrelgd=poprelgd/popd
gen pelnprd=percrelgd*ln(1/percrelgd)
egen theilreld=total(pelnprd), by(kabid)

gen sqprd=percrelgd^2
egen hreld=total(sqprd), by(kabid)
gen relfractd=1-hreld

by kabid: gen numrelgd=_N
gen lgrg40d=0
by kabid: egen mxrgd = max(percrelgd)
by kabid: replace lgrg40d=1 if mxrgd>=.4

keep prop kabid p07 percrelgd poprelgd theilreld relfractd lgrg40d

sort kabid p07
save indrgdtemp, replace

**********************
**Generate Educ Vars**
**********************
restore
preserve


sort villageid
merge villageid using indvil
drop _merge

sort kabid kecid villageid
merge kabid using indd
drop _merge


**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

sort kabid p07

merge kabid p07 using indrgdtemp 
drop _merge
sort kabid 
merge kabid using indd, keep(mnyredd)
drop _merge



keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort kabid p07
by kabid p07: egen mdyredrgd=median(yrsedygm)
by kabid p07: egen mnyredrgd=mean(yrsedygm)
by kabid p07: gen nymrgd=_N

by kabid p07: keep if _n==1

gen uwgcovrgcmd=(mnyredrgd-mnyredd)^2
gen wgcovrgcmd=percrelgd*uwgcovrgcmd
by kabid: egen wgcovrgcmdsum=total(wgcovrgcmd)
gen wgcovrgd=(wgcovrgcmdsum^.5)/mnyredd

gen gthrgcmpd=percrelgd*(mnyredrgd/mnyredd)*ln(mnyredrgd/mnyredd)
by kabid: egen gtheilrgd=total(gthrgcmpd)

by kabid: keep if _n==1

keep prop kabid theilreld relfractd wgcovrgd gtheilrgd lgrg40d
sort kabid
save indrgdtemp, replace

drop _all
use indvil
sort villageid
merge villageid using indrgvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge
sort kecid villageid
merge kecid using indrgsdtemp
drop _merge
sort kabid villageid
merge kabid using indd
drop _merge
sort kabid villageid
merge kabid using indrgdtemp
drop _merge
sort kabid

**************************************************
**RELIGIOUS CLUSTERING AT VILLAGE-DISTRICT LEVEL**
**************************************************


gen dcpthrvd=(popv/popd)*(theilreld-theilrelvil)
by kabid: egen dcpthrvdsum=total(dcpthrvd)
gen relclustvd=dcpthrvdsum/theilreld

gen dcpthrsdd=(popsd/popd)*(theilreld-theilrelsd)
by kabid: egen dcpthrsddsum=total(dcpthrsdd)
gen relclustsdd=dcpthrsddsum/theilreld


keep prop kabid theilreld relfractd wgcovrgd gtheilrgd lgrg40d relclustvd relclustsdd

sort kabid
by kabid: keep if _n==1

save indrgd, replace

restore
preserve


**************************************************************************************
**************************************************************************************
*
* This section takes village data and generates subdistrict variables
* Outputs: wgcovvilsd, gtheilvilsd
* 
**************************************************************************************
**************************************************************************************

drop _all

use indvil
sort kabid villageid
merge kabid using indd
drop _merge
sort kabid villageid
gen uwgcovvilcmd=(mnyredvil-mnyredd)^2
gen wgcovvilcmd=popv*uwgcovvilcmd/popd
by kabid: egen wgcovvilcmdsum=total(wgcovvilcmd)
gen wgcovvild=(wgcovvilcmdsum^.5)/mnyredd

gen gthvilcmpd=(popv/popd)*(mnyredvil/mnyredd)*ln(mnyredvil/mnyredd)
by kabid: egen gtheilvild=total(gthvilcmpd)

by kabid: keep if _n==1

keep prop kabid wgcovvild gtheilvild

save vild, replace

restore
preserve

**************************************************************************************
**************************************************************************************
*
* This section makes district-level measures out of indiv data
* Outputs: popd popygmd mdyredd mnyredd covyredd sdyredd theilyredd giniyredd
* 
**************************************************************************************
**************************************************************************************

**************************
**Population at Province**
**************************
sort prop
by prop: gen popp=_N
by prop: sum diplygm

**********************
**Generate Educ Vars**
**********************
**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort prop
by prop: gen popygmp=_N
by prop: egen mdyredp=median(yrsedygm)
by prop: egen mnyredp=mean(yrsedygm)
by prop: egen numobsyeym=count(yrsedygm)
drop if (popygmp<=2 | numobsyeym<=2)
by prop: sum yrsedygm 
*****************************************
**Generate Vertical Inequality Measures**
*****************************************

*******
**COV**
*******

gen covyredcmp=(yrsedygm-mnyredp)^2
by prop: egen covyredcmp2=total(covyredcmp)
gen covyredp=((covyredcmp2/(popp-1))^.5)/mnyredp

**********************
**STANDARD DEVIATION**
**********************

by prop: egen sdyredp=sd(yrsedygm)

********
**GINI**
********

qui levels prop, local(reg)
gen giniyredp = .
foreach r of local reg {
	qui fastgini yrsedygm if prop==`r'
	qui replace giniyredp=r(gini) if prop==`r'
}




*********
**THEIL**
*********

gen thyredcmp=yrsedygm/mnyredp*ln(yrsedygm/mnyredp)
by prop: egen thyredcmpsum=total(thyredcmp)
gen theilyredp=thyredcmpsum/popygmp



by prop: keep if _n==1

keep prop popp popygmp mdyredp mnyredp covyredp sdyredp theilyredp giniyredp

sort prop
save indp, replace

restore
preserve


**************************************************************************************
**************************************************************************************
*
* This section makes province-level ethnic diversity measures out of individual data
* Outputs: theilethd ethfractd wgcovegd gtheilegd lgeg40d ethclustvd ethclustsdd
* 
**************************************************************************************
**************************************************************************************

sort villageid
merge villageid using indvil
drop _merge

sort prop kabid kecid villageid
merge prop using indp
drop _merge

***************************************
**Population Ethnic Group at District**
***************************************
sort prop p082
by prop p082: gen popethgp=_N
by prop p082: keep if _n==1

gen percethgp=popethgp/popp
gen pelnpep=percethgp*ln(1/percethgp)
egen theilethp=total(pelnpep), by(prop)

gen sqpep=percethgp^2
egen hethp=total(sqpep), by(prop)
gen ethfractp=1-hethp

by prop: gen numethgp=_N
gen lgeg40p=0
by prop: egen mxegp = max(percethgp)
by prop: replace lgeg40p=1 if mxegp>=.4

keep prop p082 percethgp popethgp theilethp ethfractp lgeg40p

sort prop p082
save indegptemp, replace

**********************
**Generate Educ Vars**
**********************
restore
preserve

sort villageid
merge villageid using indvil
drop _merge

sort prop kabid kecid villageid
merge prop using indp
drop _merge

**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

sort prop p082

merge prop p082 using indegptemp 
drop _merge
sort prop 
merge prop using indp, keep(mnyredp)
drop _merge



keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort prop p082
by prop p082: egen mdyredegp=median(yrsedygm)
by prop p082: egen mnyredegp=mean(yrsedygm)
by prop p082: gen nymegp=_N

by prop p082: keep if _n==1

gen uwgcovegcmp=(mnyredegp-mnyredp)^2
gen wgcovegcmp=percethgp*uwgcovegcmp
by prop: egen wgcovegcmpsum=total(wgcovegcmp)
gen wgcovegp=(wgcovegcmpsum^.5)/mnyredp

gen gthegcmpp=percethgp*(mnyredegp/mnyredp)*ln(mnyredegp/mnyredp)
by prop: egen gtheilegp=total(gthegcmpp)

by prop: keep if _n==1

keep prop theilethp ethfractp wgcovegp gtheilegp lgeg40p
sort prop
save indegptemp, replace

drop _all
use indvil
sort villageid
merge villageid using indegvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge
sort kecid villageid
merge kecid using indegsdtemp
drop _merge
sort kabid villageid
merge kabid using indd
drop _merge
sort kabid villageid
merge kabid using indegdtemp
drop _merge
sort prop villageid
merge prop using indp
drop _merge
sort prop villageid
merge prop using indegptemp
drop _merge

sort prop
***********************************************
**ETHNIC CLUSTERING AT VILLAGE-DISTRICT LEVEL**
***********************************************


gen dcpthevp=(popv/popp)*(theilethp-theilethvil)

by prop: egen dcpthevpsum=total(dcpthevp)
gen ethclustvp=dcpthevpsum/theilethp

gen dcpthesdp=(popsd/popp)*(theilethp-theilethsd)
by prop: egen dcpthesdpsum=total(dcpthesdp)
gen ethclustsdp=dcpthesdpsum/theilethp


keep prop theilethp ethfractp wgcovegp gtheilegp lgeg40p ethclustvp ethclustsdp

sort prop
by prop: keep if _n==1

save indegp, replace

restore
preserve


**************************************************************************************
**************************************************************************************
*
* This section makes province-level ethnic diversity measures out of individual data
* Outputs: theilethd ethfractd wgcovegd gtheilegd lgeg40d ethclustvd ethclustsdd
* 
**************************************************************************************
**************************************************************************************

*********************
**Generate ID Codes**
*********************

sort villageid
merge villageid using indvil
drop _merge

sort prop kabid kecid villageid
merge prop using indp
drop _merge

******************************************
**Population Religious Group at Province**
******************************************
sort prop p07
by prop p07: gen poprelgp=_N
by prop p07: keep if _n==1

gen percrelgp=poprelgp/popp
gen pelnprp=percrelgp*ln(1/percrelgp)
egen theilrelp=total(pelnprp), by(prop)

gen sqprp=percrelgp^2
egen hrelp=total(sqprp), by(prop)
gen relfractp=1-hrelp

by prop: gen numrelgp=_N
gen lgrg40p=0
by prop: egen mxrgp = max(percrelgp)
by prop: replace lgrg40p=1 if mxrgp>=.4

keep prop p07 percrelgp poprelgp theilrelp relfractp lgrg40p

sort prop p07
save indrgptemp, replace

**********************
**Generate Educ Vars**
**********************
restore
preserve

sort villageid
merge villageid using indvil
drop _merge

sort prop kabid kecid villageid
merge prop using indp
drop _merge

**Look at young men between ages 24 and 33.  We don't want to start at 20 because
**that wouldn't allow for people to get through college

sort prop p07

merge prop p07 using indrgptemp 
drop _merge
sort prop 
merge prop using indp, keep(mnyredp)
drop _merge



keep if (p05b>=24 & p05b<=33 & p03==1)
gen yrsedygm=.
replace yrsedygm=0 if diplygm==1
replace yrsedygm=6 if diplygm==2
replace yrsedygm=9 if diplygm==3
replace yrsedygm=12 if diplygm==4
replace yrsedygm=13 if diplygm==5
replace yrsedygm=15 if diplygm==6
replace yrsedygm=16 if diplygm==7

sort prop p07
by prop p07: egen mdyredrgp=median(yrsedygm)
by prop p07: egen mnyredrgp=mean(yrsedygm)
by prop p07: gen nymrgp=_N

by prop p07: keep if _n==1

gen uwgcovrgcmp=(mnyredrgp-mnyredp)^2
gen wgcovrgcmp=percrelgp*uwgcovrgcmp
by prop: egen wgcovrgcmpsum=total(wgcovrgcmp)
gen wgcovrgp=(wgcovrgcmpsum^.5)/mnyredp

gen gthrgcmpp=percrelgp*(mnyredrgp/mnyredp)*ln(mnyredrgp/mnyredp)
by prop: egen gtheilrgp=total(gthrgcmpp)

by prop: keep if _n==1

keep prop theilrelp relfractp wgcovrgp gtheilrgp lgrg40p
sort prop
save indrgptemp, replace

drop _all
use indvil
sort villageid
merge villageid using indrgvil
drop _merge
sort kecid villageid
merge kecid using indsd
drop _merge
sort kecid villageid
merge kecid using indrgsdtemp
drop _merge
sort kabid villageid
merge kabid using indd
drop _merge
sort kabid villageid
merge kabid using indrgdtemp
drop _merge
sort prop villageid
merge prop using indp
drop _merge
sort prop villageid
merge prop using indrgptemp
drop _merge

sort prop
**************************************************
**RELIGIOUS CLUSTERING AT VILLAGE-PROVINCE LEVEL**
**************************************************


gen dcpthrvp=(popv/popp)*(theilrelp-theilrelvil)

by prop: egen dcpthrvpsum=total(dcpthrvp)
gen relclustvp=dcpthrvpsum/theilrelp

gen dcpthrsdp=(popsd/popp)*(theilrelp-theilrelsd)
by prop: egen dcpthrsdpsum=total(dcpthrsdp)
gen relclustsdp=dcpthrsdpsum/theilrelp


keep prop theilrelp relfractp wgcovrgp gtheilrgp lgrg40p relclustvp relclustsdp

sort prop
by prop: keep if _n==1

save indrgp, replace

restore


**************************************************************************************
**************************************************************************************
*
* This section takes village data and generates subdistrict variables
* Outputs: wgcovvilsd, gtheilvilsd
* 
**************************************************************************************
**************************************************************************************

drop _all

use indvil
sort villageid
merge using indp
drop _merge
sort villageid
gen uwgcovvilcmp=(mnyredvil-mnyredp)^2
gen wgcovvilcmp=popv*uwgcovvilcmp/popp
egen wgcovvilcmpsum=total(wgcovvilcmp)
gen wgcovvilp=(wgcovvilcmpsum^.5)/mnyredp

gen gthvilcmpp=(popv/popp)*(mnyredvil/mnyredp)*ln(mnyredvil/mnyredp)
egen gtheilvilp=total(gthvilcmpp)

keep if _n==1

keep prop wgcovvilp gtheilvilp

sort prop
save vilp, replace

***************************************************************************
***************************************************************************
****Merge tempfiles
***************************************************************************
***************************************************************************

clear
use indvil

sort villageid
merge villageid using indegvil
drop _merge

sort villageid
merge villageid using indrgvil
drop _merge

sort kecid villageid
merge kecid using indsd
drop _merge

sort kecid villageid
merge kecid using indegsd
drop _merge

sort kecid villageid
merge kecid using indrgsd
drop _merge

sort kecid villageid
merge kecid using vilsd
drop _merge

sort kabid kecid villageid
merge kabid using indd
drop _merge

sort kabid kecid villageid
merge kabid using indegd
drop _merge

sort kabid kecid villageid
merge kabid using indrgd
drop _merge

sort kabid kecid villageid
merge kabid using vild
drop _merge

sort prop kabid kecid villageid
merge prop using indp
drop _merge

sort prop kabid kecid villageid
merge prop using indegp
drop _merge

sort prop kabid kecid villageid
merge prop using indrgp
drop _merge

sort prop kabid kecid villageid
merge prop using vilp
drop _merge

sort villageid
save provmerged, replace

