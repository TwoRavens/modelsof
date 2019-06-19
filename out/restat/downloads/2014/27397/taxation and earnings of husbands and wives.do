capture log close

log using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\052312.smcl", replace

clear all

set more off

set mem 900m

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda88pu.dta", clear

append using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda88uu.dta"

sort bidnr

duplicates drop bidnr, force

	rename skslut skslut88

	rename insbesk bai88 
	
	rename utillag eai88

	rename intj intj88

	gen hous88=ufasts
	
	gen ei88 = arbink  

	rename inkap inkap88

         destring manavgr, replace

         gen ded88=avrese+avlomk+avsallm+avgr+avsext+manavgr

	sort bidnr
		
	save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda88allmrg.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda89pu.dta", clear

append using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda89uu.dta"

sort bidnr

duplicates drop bidnr, force

	rename skslut skslut89	

	rename insbesk bai89
	
	rename utillag eai89

	rename intj intj89

	gen ei89 = arbink 

	gen hous89=ufasts
	
	rename inkap inkap89

	sort bidnr

         destring manavgr, replace

         gen ded89=avrese+avlomk+avsallm+avgr+avsext+manavgr

	save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda89allmrg.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda90pu.dta", clear

append using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda90uu.dta"

sort bidnr

duplicates drop bidnr, force

	rename skslut skslut90

	rename insbesk bai90
	
	rename utillag eai90

	rename intj intj90

	gen ei90 = arbink 

	gen hous90=ufasts
	
	rename inkap inkap90

	sort bidnr

         destring manavgr, replace
 
         gen ded90=avrese+avlomk+avsallm+avgr+avsext+manavgr

	save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda90allmrg.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda91fu.dta", clear

append using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda91uu.dta"

sort bidnr

duplicates drop bidnr, force

	rename staxforv ai91 
	
	rename intj intj91 

	gen ei91 = carbl 

	gen hous91=ufasts2
	
	rename inkap inkap91
	
	gen ded91=avrese+avkost+avtjres+avdubb

	sort bidnr
		
	save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda91allmrg.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda89allmrg.dta", clear

merge bidnr using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda90allmrg.dta", keep(utbildn)

drop _merge

sort bidnr

foreach thing in 88 90  {

	merge bidnr using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda`thing'allmrg.dta", keep(intj`thing' ei`thing' inkap`thing' bai`thing' eai`thing' skslut`thing' ded`thing' hous`thing')

	keep if _merge==3

	sort bidnr

	rename intj`thing' intj`thing'w

	rename inkap`thing' inkap`thing'w

	rename ei`thing' ei`thing'w

	rename bai`thing' bai`thing'w

	rename eai`thing' eai`thing'w

	rename ded`thing' ded`thing'w
	
	rename hous`thing' hous`thing'w
	
	rename _merge _merge`thing'

}

	merge bidnr using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\linda91allmrg.dta", keep(intj91 ei91 inkap91 ai91 ded91 hous91)

	keep if _merge==3

	sort bidnr

	rename intj91 intj91w

	rename inkap91 inkap91w

	rename ei91 ei91w

	rename ai91 ai91w

	rename hous91 hous91w
	
	rename _merge _merge91

rename alder agew

rename utbildn educw

replace educw="99" if educw==""

destring educw, replace

gen educwint = int(educw/1000)

rename lan countyw

rename kusni industryw

rename kuinst occupw

rename barny barnyw

rename barnae barnaew

rename inasjor inasjorw

rename inbsjor inbsjorw

rename insror insrorw

rename foab foabw

destring occupw, replace

gen sector=.

replace sector = int(occupw/100)

replace sector=99 if occupw==.

destring agew, replace

gen agewsq = agew*agew

gen married = civr=="02"|civr=="03"|civr=="07"|civr=="10"|civr=="11"

gen single=civr=="01"

destring foabw, replace

replace foabw=0 if foabw==.

replace inasjorw=0 if inasjorw==.

replace inbsjorw=0 if inbsjorw==.

replace insrorw=0 if insrorw==.

gen selfempw=foabw>0|inasjorw>0|inbsjorw>0|insrorw>0

destring barnyw, replace

destring barnaew, replace

gen childrenw = barnyw+barnaew

tab countyw, gen(countywd)

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\main-fastv5.dta", replace

clear 

set more off

set mem 900m

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\main-fastv5.dta", clear

rename occupw ocup

gen occup = 99

replace occup = 1 if ocup==1118

replace occup = 2 if ocup==1228

replace occup = 3 if ocup==1328

replace occup = 4 if ocup==1428

replace occup = 5 if ocup==2114

replace occup = 6 if ocup==2117

replace occup = 7 if ocup==2118

replace occup = 8 if ocup==2124

replace occup = 9 if ocup==2193

replace occup = 10 if ocup==2194

replace occup = 11 if ocup==2195

replace occup = 12 if ocup==4191

replace occup = 13 if ocup==5096

replace occup = 14 if ocup==5097

replace occup = 15 if ocup==3399

replace occup = 16 if ocup==3194

replace occup = 17 if ocup==.

gen basicntr88=.

replace basicntr88=.05 if bai88w<700

replace basicntr88=.2 if bai88w>=700

gen extrantr88=.

replace extrantr88=0 if eai88w<1400

replace extrantr88=.14 if eai88w>=1400&eai88w<1900

replace extrantr88=.25 if eai88w>=1900

gen ntr88w=.

replace ntr88w=1-basicntr88-extrantr88-.31

tab educw, gen(educwd)

tab occup, gen(occup)

rename bai89 bai89w

rename eai89 eai89w

rename ei89 ei89w

rename inkap89 inkap89w

rename intj89 intj89w

gen basicntr89=.

replace basicntr89=.05 if bai89w<750

replace basicntr89=.17 if bai89w>=750

gen extrantr89=.

replace extrantr89=0 if eai89w<1400

replace extrantr89=.14 if eai89w>=1400&eai89w<1900

replace extrantr89=.25 if eai89w>=1900

gen ntr89w=.

replace ntr89w=1-basicntr89-extrantr89-.31

gen basicntr90=.

replace basicntr90=.03 if bai90w<750

replace basicntr90=.1 if bai90w>=750

gen extrantr90=.

replace extrantr90=0 if eai90w<1400

replace extrantr90=.14 if eai90w>=1400&eai90w<1900

replace extrantr90=.25 if eai90w>=1900

gen ntr90w=.

replace ntr90w=1-basicntr90-extrantr90-.31

gen ntr91w=.

replace ntr91w=.69 if ai91w<=598.92

replace ntr91w=.7675 if ai91w>598.92&ai91w<=930.58

replace ntr91w=.69 if ai91w>930.58&ai91w<=978.88

replace ntr91w=.659 if ai91w>978.88&ai91w<=1798.88

replace ntr91w=.69 if ai91w>1798.88&ai91w<=1803

replace ntr91w=.49 if ai91w>1803

gen bai89i = bai88w*1.1339333

gen bai90i = bai89w*1.1554284

gen eai89i = eai88w*1.152658

gen eai90i = eai89w*1.1396876

gen ai91wi = intj90*1.1017067

gen basicntr89i=.

replace basicntr89i=.05 if bai89i<750

replace basicntr89i=.17 if bai89i>=750

gen extrantr89i=.

replace extrantr89i=0 if eai89i<1400

replace extrantr89i=.14 if eai89i>=1400&eai89i<1900

replace extrantr89i=.25 if eai89i>=1900

gen ntr89wi=.

replace ntr89wi=1-basicntr89i-extrantr89i-.31

gen basicntr90i=.

replace basicntr90i=.03 if bai90i<750

replace basicntr90i=.1 if bai90i>=750

gen extrantr90i=.

replace extrantr90i=0 if eai90i<1400

replace extrantr90i=.14 if eai90i>=1400&eai90i<1900

replace extrantr90i=.25 if eai90i>=1900

gen ntr90wi=.

replace ntr90wi=1-basicntr90i-extrantr90i-.31

gen ntr91wi=.

replace ntr91wi=.69 if ai91wi<=1803

replace ntr91wi=.49 if ai91wi>1803

gen dlntr8988wi = ln(ntr89wi)-ln(ntr88w) 

gen dlntr9089wi = ln(ntr90wi)-ln(ntr89w) 

gen dlntr9190wi = ln(ntr91wi)-ln(ntr90w) 

gen dlntr8988w = ln(ntr89w)-ln(ntr88w) 

gen dlntr9089w = ln(ntr90w)-ln(ntr89w) 

gen dlntr9190w = ln(ntr91w)-ln(ntr90w) 

gen dhous9190w=(hous91-hous90)/hous90

gen dhous9089w=(hous90-hous89)/hous89

gen dhous8988w=(hous89-hous88)/hous88

destring countyw, gen(countyw_destring)

replace countyw_destring=26 if countyw_destring==.

sort countyw_destring

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\housinter.dta", replace

collapse (mean) dhous9190w-dhous8988w, by(countyw_destring)

sort countyw

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\housinter2.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\housinter.dta", clear

drop dhous9190w-dhous8988w

merge countyw_destring using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\housinter2.dta", keep(dhous9190w dhous9089w dhous8988w)

capture gen bvi88w=.

replace bvi88w=1 if bai88w<=700

replace bvi88w=150 if bai88w>700

capture gen evi88w=.

replace evi88w = 1 if eai88w<=1400

replace evi88w = 196 if eai88w>1400&eai88w<=1900

replace evi88w = 545 if eai88w>1900

gen vi88w = evi88w+bvi88w+inkap88

capture gen bvi89w=.

replace bvi89w=1 if bai89w<=700

replace bvi89w=150-750*.05 if bai89w>700

capture gen evi89w=.

replace evi89w = 1 if eai89w<=1400

replace evi89w = 196 if eai89w>1400&eai89w<=1900

replace evi89w = 545 if eai89w>1900

gen vi89w = evi89w+bvi89w+inkap89

capture gen evi90w=.

replace evi90w = 1 if eai90w<=1400

replace evi90w = 196 if eai90w>1400&eai90w<=1900

replace evi90w = 545 if eai90w>1900

gen bvi90w=.

replace bvi90w=1 if bai90w<=750

replace bvi90w=150-750*.03 if bai90w>750

gen vi90w = evi90w+bvi90w+inkap90

gen vi91w=.

replace vi91w=31.93 +max(inkap91,0) if ai91w<=1803

replace vi91w=392.81365+max(inkap91,0) if ai91w>1803

capture gen evi90wi=.

replace evi90wi = 1 if eai90i<=1400

replace evi90wi = 196 if eai90i>1400&eai90i<=1900

replace evi90wi = 545 if eai90i>1900

gen bvi90wi=.

replace bvi90wi=1 if bai90i<=750

replace bvi90wi=150-750*.03 if bai90i>750

gen vi90wi = evi90wi+bvi90wi+inkap90

gen vi91wi=.

rename ai91wi intj91wi

replace vi91wi=31.93+max(inkap91,0) if intj91wi<=1803

replace vi91wi=392.81365+max(inkap91,0) if intj91wi>1803

destring industryw, replace

replace industryw = int(industryw/1000)

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8v2.dta", replace

clear

set mem 900m

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8v2.dta", clear

gen vi89wi=.

gen rei88=ei88

gen rei89 = ei89/1.058

gen rei90 = ei90/(1.058*1.064)

gen rei91 = ei91/(1.058*1.064*1.105)

gen rded88=ded88

gen rded89 = ded89/1.058
 
gen rded90 = ded90/(1.058*1.064)

gen rded91 = ded91/(1.058*1.064*1.105)

replace vi89w = vi89w/1.058

replace vi90w = vi90w / (1.058*1.064)

replace vi91w = vi91w/(1.058*1.064*1.105)

replace vi89wi = vi89wi/1.058

replace vi90wi = vi90wi / (1.058*1.064)

replace vi91wi = vi91wi/(1.058*1.064*1.105)

gen lrei91 = ln(rei91+1)

gen lrei90 = ln(rei90+1)

gen lrei89 = ln(rei89+1)

gen lrei88 = ln(rei88+1)

gen dlrei9190 = lrei91-lrei90

gen dlrei9089 = lrei90-lrei89

gen dlrei8988 = lrei89-lrei88

gen lrai88= ln(eai88+1)

gen lrai89 = ln((eai89w/1.058)+1)

gen lrai90 = ln((eai90w/(1.058*1.064))+1)

gen lrai91 = ln(ai91w/((1.058*1.064*1.105))+1)

gen d = civ=="02"|civ=="07"

#delimit;

keep bidnr burvkodu bidnrh agew agewsq countyw  
educw childrenw selfempw married single
dlrei8988 dlrei9089 dlrei9190 
lrei88 lrei89 lrei90 lrei91 
lrai88 lrai89 lrai90 lrai91 
rei88 rei89 rei90 rei91 
rded88 rded89 rded90 rded91 
dlntr9190w dlntr9089w dlntr8988w 
dlntr9190wi dlntr9089wi dlntr8988wi
vi88w vi89w vi90w vi91w
vi89wi vi90wi vi91wi 
industryw bkon civ occup d
ntr88w ntr89w ntr90w ntr91w
dhous9190w dhous9089w dhous8988w;

stack 
dlntr9190w dlntr9190wi dhous9190w
dlrei9190 lrei90 lrai90 rei91 rei90 rded91 rded90 vi91w vi90w vi91wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr91w
dlntr9089w dlntr9089wi dhous9089w
dlrei9089 lrei89 lrai89 rei90 rei89 rded90 rded89 vi90w vi89w vi90wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr90w
dlntr8988w dlntr8988wi dhous8988w
dlrei8988 lrei88 lrai88 rei89 rei88 rded89 rded88  vi89w vi88w vi89wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr89w,
into(dlntrw dlntrwi dhousw
dlrei lreilag lrailag rei reilag rded rdedlag viw vilagw viwi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industryw civ d ntrw) clear;

#delimit cr

rename _stack yr

gen gdp=.

tab yr, gen(yrd)

tab countyw, gen(countywd)

rename occup occupw

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-stackv2.dta", replace

keep if civ=="07"

sort bidnrh yr

rename dlrei dlreiw

rename lreilag lreilagw

rename lrailag lrailagw

rename rei reiw

rename reilag reilagw

rename rded rdedw

rename rdedlag rdedlagw

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-wifev2.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-stackv2.dta", clear

keep if civ=="02"

sort bidnrh yr

rename agew ageh

rename agewsq agehsq 

rename dhousw dhoush

rename selfempw selfemph

rename occupw occuph

rename educw educh

rename industryw industryh

rename dlntrw dlntrh 

rename dlntrwi dlntrhi 

rename dlrei dlreih 

rename rded rdedh

rename rdedlag rdedlagh

rename lreilag lreilagh

rename lrailag lrailagh

rename rei reih

rename reilag reilagh

rename viw vih 

rename vilagw vilagh 

rename viwi vihi

rename ntrw ntrh

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-husbv2.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-husbv2.dta", clear

tab occuph, gen(occuphd)

replace industryh=99 if industryh==.

tab industryh, gen(industryhd)

#delimit ;

merge bidnrh yr using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-wifev2.dta"
, keep(agew agewsq educw dlntrw dlntrwi viw vilagw viwi
dlreiw lreilagw lrailagw reiw reilagw industryw selfempw occupw ntrw rdedw rdedlagw dhousw) ;

gen selfempfam = selfemph|selfempw;

keep if _merge==3;

#delimit cr

gen vish = vih+reiw

gen vishi = vihi+reiw

gen visw = viw+reih

gen viswi = viwi+reih

gen vislagh = vilagh+reilagw

gen vislagw = vilagw+reilagh

gen dlvish = ln(vish) - ln(vislagh)

gen dlvisw = ln(visw) - ln(vislagw)

gen dlvishi = ln(vishi) - ln(vislagh)

gen dlviswi = ln(viswi) - ln(vislagw)

tab occupw, gen(occupwd)

tab educw, gen(educwd)

tab educh, gen(educhd)

replace industryw=99 if industryw==.

tab industryw, gen(industrywd)

#delimit;

mkspline sh 10 = lreilagh if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline sw 10 = lreilagw if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline sah 10 = lrailagh if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline saw 10 = lrailagw if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

reg dlreih sh* sw* sah* saw* ageh agehsq educhd* agew agewsq educwd*
 occuphd* occupwd* countywd* if yrd3&lreilagh>0;

matrix Bh = e(b);

#delimit;

matrix Bhshort = Bh["y1", "sh1".."saw10"];

scalar bshh1 = Bhshort[1,1];

scalar bshh2 = Bhshort[1,2];

scalar bshh3 = Bhshort[1,3];

scalar bshh4 = Bhshort[1,4];

scalar bshh5 = Bhshort[1,5];

scalar bshh6 = Bhshort[1,6];

scalar bshh7 = Bhshort[1,7];

scalar bshh8 = Bhshort[1,8];

scalar bshh9 = Bhshort[1,9];

scalar bshh10 = Bhshort[1,10];

scalar bshw1 = Bhshort[1,11];

scalar bshw2 = Bhshort[1,12];

scalar bshw3 = Bhshort[1,13];

scalar bshw4 = Bhshort[1,14];

scalar bshw5 = Bhshort[1,15];

scalar bshw6 = Bhshort[1,16];

scalar bshw7 = Bhshort[1,17];

scalar bshw8 = Bhshort[1,18];

scalar bshw9 = Bhshort[1,19];

scalar bshw10 = Bhshort[1,20];

scalar bsahh1 = Bhshort[1,21];

scalar bsahh2 = Bhshort[1,22];

scalar bsahh3 = Bhshort[1,23];

scalar bsahh4 = Bhshort[1,24];

scalar bsahh5 = Bhshort[1,25];

scalar bsahh6 = Bhshort[1,26];

scalar bsahh7 = Bhshort[1,27];

scalar bsahh8 = Bhshort[1,28];

scalar bsahh9 = Bhshort[1,29];

scalar bsahh10 = Bhshort[1,30];

scalar bsahw1 = Bhshort[1,31];

scalar bsahw2 = Bhshort[1,32];

scalar bsahw3 = Bhshort[1,33];

scalar bsahw4 = Bhshort[1,34];

scalar bsahw5 = Bhshort[1,35];

scalar bsahw6 = Bhshort[1,36];

scalar bsahw7 = Bhshort[1,37];

scalar bsahw8 = Bhshort[1,38];

scalar bsahw9 = Bhshort[1,39];

scalar bsahw10 = Bhshort[1,40];

reg dlreiw sh* sw* sah* saw* ageh agehsq educhd* agew agewsq educwd* 
 occuphd* occupwd* countywd*  if yrd3&lreilagw>0;

matrix Bw = e(b);

matrix Bwshort = Bw["y1", "sh1".."saw10"];

scalar bswh1 = Bwshort[1,1];

scalar bswh2 = Bwshort[1,2];

scalar bswh3 = Bwshort[1,3];

scalar bswh4 = Bwshort[1,4];

scalar bswh5 = Bwshort[1,5];

scalar bswh6 = Bwshort[1,6];

scalar bswh7 = Bwshort[1,7];

scalar bswh8 = Bwshort[1,8];

scalar bswh9 = Bwshort[1,9];

scalar bswh10 = Bwshort[1,10];

scalar bsww1 = Bwshort[1,11];

scalar bsww2 = Bwshort[1,12];

scalar bsww3 = Bwshort[1,13];

scalar bsww4 = Bwshort[1,14];

scalar bsww5 = Bwshort[1,15];

scalar bsww6 = Bwshort[1,16];

scalar bsww7 = Bwshort[1,17];

scalar bsww8 = Bwshort[1,18];

scalar bsww9 = Bwshort[1,19];

scalar bsww10 = Bwshort[1,20];

scalar bsawh1 = Bwshort[1,21];

scalar bsawh2 = Bwshort[1,22];

scalar bsawh3 = Bwshort[1,23];

scalar bsawh4 = Bwshort[1,24];

scalar bsawh5 = Bwshort[1,25];

scalar bsawh6 = Bwshort[1,26];

scalar bsawh7 = Bwshort[1,27];

scalar bsawh8 = Bwshort[1,28];

scalar bsawh9 = Bwshort[1,29];

scalar bsawh10 = Bwshort[1,30];

scalar bsaww1 = Bwshort[1,31];

scalar bsaww2 = Bwshort[1,32];

scalar bsaww3 = Bwshort[1,33];

scalar bsaww4 = Bwshort[1,34];

scalar bsaww5 = Bwshort[1,35];

scalar bsaww6 = Bwshort[1,36];

scalar bsaww7 = Bwshort[1,37];

scalar bsaww8 = Bwshort[1,38];

scalar bsaww9 = Bwshort[1,39];

scalar bsaww10 = Bwshort[1,40];

drop sh* sw* sah* saw*;

mkspline sh 10 = lreilagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline sw 10 = lreilagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline sah 10 = lrailagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline saw 10 = lrailagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

gen dlreihm = dlreih - bshh1*sh1 - bshh2*sh2 - bshh3*sh3 - bshh4*sh4 -bshh5*sh5
- bshh6*sh6 - bshh6*sh6 - bshh7*sh7 - bshh8*sh8 - bshh9*sh9 - bshh10*sh10 
- bshw1*sw1 - bshw2*sw2 - bshw3*sw3 - bshw4*sw4 -bshw5*sw5
- bshw6*sw6 - bshw7*sw7 - bshw8*sw8 - bshw9*sw9 -bshw10*sw10
- bsahh1*sah1 - bsahh2*sah2 - bsahh3*sah3 - bsahh4*sah4 -bsahh5*sah5
- bsahh6*sah6 - bsahh7*sah7 - bsahh8*sah8 - bsahh9*sah9 -bsahh10*sah10
- bsahw1*saw1 - bsahw2*saw2 - bsahw3*saw3 - bsahw4*saw4 -bsahw5*saw5
- bsahw6*saw6 - bsahw7*saw7 - bsahw8*saw8 - bsahw9*saw9 -bsahw10*saw10;

gen dlreiwm = dlreiw - bswh1*sh1 - bswh2*sh2 - bswh3*sh3 - bswh4*sh4 -bswh5*sh5
- bswh6*sh6 - bswh6*sh6 - bswh7*sh7 - bswh8*sh8 - bswh9*sh9 - bswh10*sh10 
- bsww1*sw1 - bsww2*sw2 - bsww3*sw3 - bsww4*sw4 -bsww5*sw5
- bsww6*sw6 - bsww7*sw7 - bsww8*sw8 - bsww9*sw9 -bsww10*sw10
- bsawh1*sah1 - bsawh2*sah2 - bsawh3*sah3 - bsawh4*sah4 -bsawh5*sah5
- bsawh6*sah6 - bsawh7*sah7 - bsawh8*sah8 - bsawh9*sah9 -bsawh10*sah10
- bsaww1*saw1 - bsaww2*saw2 - bsaww3*saw3 - bsaww4*saw4 -bsaww5*saw5
- bsaww6*saw6 - bsaww7*saw7 - bsaww8*saw8 - bsaww9*saw9 -bsaww10*saw10;

 gen tlih = max(reih-rdedh,0);

 gen tliw = max(reiw-rdedw,0);

 gen tlilagh = max(reilagh-rdedlagh,0);

 gen tlilagw = max(reilagw-rdedlagw,0);

 gen lrtlilagh = ln(tlilagh+1);

 gen lrtlilagw = ln(tlilagw+1);

 gen dlrtlih = ln(tlih+1) - ln(tlilagh+1);

 gen dlrtliw = ln(tliw+1) - ln(tlilagw+1);

 mkspline shtli 10 = lrtlilagh if lreilagh>0&lreilagw>0&agew<65& 
ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline swtli 10 = lrtlilagw if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline sahtli 10 = lrailagh if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline sawtli 10 = lrailagw if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 reg dlrtlih shtli* swtli* sahtli* sawtli* ageh agehsq educhd* agew agewsq educwd*
  occuphd* occupwd* countywd* if yrd3&lreilagh>0;

 matrix Bhtli = e(b);

 matrix Bhshorttli = Bhtli["y1", "shtli1".."sawtli10"];

 scalar bshhtli1 = Bhshorttli[1,1];

 scalar bshhtli2 = Bhshorttli[1,2];

 scalar bshhtli3 = Bhshorttli[1,3];

 scalar bshhtli4 = Bhshorttli[1,4];

 scalar bshhtli5 = Bhshorttli[1,5];

 scalar bshhtli6 = Bhshorttli[1,6];

 scalar bshhtli7 = Bhshorttli[1,7];

 scalar bshhtli8 = Bhshorttli[1,8];

 scalar bshhtli9 = Bhshorttli[1,9];

 scalar bshhtli10 = Bhshorttli[1,10];

 scalar bshwtli1 = Bhshorttli[1,11];

 scalar bshwtli2 = Bhshorttli[1,12];

 scalar bshwtli3 = Bhshorttli[1,13];

 scalar bshwtli4 = Bhshorttli[1,14];

 scalar bshwtli5 = Bhshorttli[1,15];

 scalar bshwtli6 = Bhshorttli[1,16];

 scalar bshwtli7 = Bhshorttli[1,17];

 scalar bshwtli8 = Bhshorttli[1,18];

 scalar bshwtli9 = Bhshorttli[1,19];

 scalar bshwtli10 = Bhshorttli[1,20];

 scalar bsahhtli1 = Bhshorttli[1,21];

 scalar bsahhtli2 = Bhshorttli[1,22];

 scalar bsahhtli3 = Bhshorttli[1,23];

 scalar bsahhtli4 = Bhshorttli[1,24];

 scalar bsahhtli5 = Bhshorttli[1,25];

 scalar bsahhtli6 = Bhshorttli[1,26];

 scalar bsahhtli7 = Bhshorttli[1,27];

 scalar bsahhtli8 = Bhshorttli[1,28];

 scalar bsahhtli9 = Bhshorttli[1,29];

 scalar bsahhtli10 = Bhshorttli[1,30];

 scalar bsahwtli1 = Bhshorttli[1,31];

 scalar bsahwtli2 = Bhshorttli[1,32];

 scalar bsahwtli3 = Bhshorttli[1,33];

 scalar bsahwtli4 = Bhshorttli[1,34];

 scalar bsahwtli5 = Bhshorttli[1,35];

 scalar bsahwtli6 = Bhshorttli[1,36];

 scalar bsahwtli7 = Bhshorttli[1,37];

 scalar bsahwtli8 = Bhshorttli[1,38];

 scalar bsahwtli9 = Bhshorttli[1,39];

 scalar bsahwtli10 = Bhshorttli[1,40];

 reg dlrtliw shtli* swtli* sahtli* sawtli* ageh agehsq educhd* agew agewsq educwd* 
  occuphd* occupwd* countywd*  if yrd3&lreilagw>0;

 matrix Bwtli = e(b);

 matrix Bwshorttli = Bwtli["y1", "shtli1".."sawtli10"];

 scalar bswhtli1 = Bwshorttli[1,1];

 scalar bswhtli2 = Bwshorttli[1,2];

 scalar bswhtli3 = Bwshorttli[1,3];

 scalar bswhtli4 = Bwshorttli[1,4];

 scalar bswhtli5 = Bwshorttli[1,5];

 scalar bswhtli6 = Bwshorttli[1,6];

 scalar bswhtli7 = Bwshorttli[1,7];

 scalar bswhtli8 = Bwshorttli[1,8];

 scalar bswhtli9 = Bwshorttli[1,9];

 scalar bswhtli10 = Bwshorttli[1,10];

 scalar bswwtli1 = Bwshorttli[1,11];

 scalar bswwtli2 = Bwshorttli[1,12];

 scalar bswwtli3 = Bwshorttli[1,13];

 scalar bswwtli4 = Bwshorttli[1,14];

 scalar bswwtli5 = Bwshorttli[1,15];

 scalar bswwtli6 = Bwshorttli[1,16];

 scalar bswwtli7 = Bwshorttli[1,17];

 scalar bswwtli8 = Bwshorttli[1,18];

 scalar bswwtli9 = Bwshorttli[1,19];

 scalar bswwtli10 =Bwshorttli[1,20];

 scalar bsawhtli1 = Bwshorttli[1,21];

 scalar bsawhtli2 = Bwshorttli[1,22];

 scalar bsawhtli3 = Bwshorttli[1,23];

 scalar bsawhtli4 = Bwshorttli[1,24];

 scalar bsawhtli5 = Bwshorttli[1,25];

 scalar bsawhtli6 = Bwshorttli[1,26];

 scalar bsawhtli7 = Bwshorttli[1,27];

 scalar bsawhtli8 = Bwshorttli[1,28];

 scalar bsawhtli9 = Bwshorttli[1,29];

 scalar bsawhtli10 =Bwshorttli[1,30];

 scalar bsawwtli1 = Bwshorttli[1,31];

 scalar bsawwtli2 = Bwshorttli[1,32];

 scalar bsawwtli3 = Bwshorttli[1,33];

 scalar bsawwtli4 = Bwshorttli[1,34];

 scalar bsawwtli5 = Bwshorttli[1,35];

 scalar bsawwtli6 = Bwshorttli[1,36];

 scalar bsawwtli7 = Bwshorttli[1,37];

 scalar bsawwtli8 = Bwshorttli[1,38];

 scalar bsawwtli9 = Bwshorttli[1,39];

 scalar bsawwtli10 = Bwshorttli[1,40];

 drop shtli* swtli* sahtli* sawtli*;

 mkspline sht 10 = lrtlilagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline swt 10 = lrtlilagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline saht 10 = lrailagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline sawt 10 = lrailagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 gen dlrtlihm = dlrtlih - bshhtli1*sht1 - bshhtli2*sht2 - bshhtli3*sht3 - bshhtli4*sht4 -bshhtli5*sht5
 - bshhtli6*sht6 - bshhtli6*sht6 - bshhtli7*sht7 - bshhtli8*sht8 - bshhtli9*sht9 - bshhtli10*sht10 
 - bshwtli1*swt1 - bshwtli2*swt2 - bshwtli3*swt3 - bshwtli4*swt4 -bshwtli5*swt5
 - bshwtli6*swt6 - bshwtli7*swt7 - bshwtli8*swt8 - bshwtli9*swt9 -bshwtli10*swt10
 - bsahhtli1*saht1 - bsahhtli2*saht2 - bsahhtli3*saht3 - bsahhtli4*saht4 -bsahhtli5*saht5
 - bsahhtli6*saht6 - bsahhtli7*saht7 - bsahhtli8*saht8 - bsahhtli9*saht9 -bsahhtli10*saht10
 - bsahwtli1*sawt1 - bsahwtli2*sawt2 - bsahwtli3*sawt3 - bsahwtli4*sawt4 -bsahwtli5*sawt5
 - bsahwtli6*sawt6 - bsahwtli7*sawt7 - bsahwtli8*sawt8 - bsahwtli9*sawt9 -bsahwtli10*sawt10;

 gen dlrtliwm = dlrtliw - bswhtli1*sht1 - bswhtli2*sht2 - bswhtli3*sht3 - bswhtli4*sht4 -bswhtli5*sht5
 - bswhtli6*sht6 - bswhtli6*sht6 - bswhtli7*sht7 - bswhtli8*sht8 - bswhtli9*sht9 - bswhtli10*sht10 
 - bswwtli1*swt1 - bswwtli2*swt2 - bswwtli3*swt3 - bswwtli4*swt4 -bswwtli5*swt5
 - bswwtli6*swt6 - bswwtli7*swt7 - bswwtli8*swt8 - bswwtli9*swt9 -bswwtli10*swt10
 - bsawhtli1*saht1 - bsawhtli2*saht2 - bsawhtli3*saht3 - bsawhtli4*saht4 -bsawhtli5*saht5
 - bsawhtli6*saht6 - bsawhtli7*saht7 - bsawhtli8*saht8 - bsawhtli9*saht9 -bsawhtli10*saht10
 - bsawwtli1*sawt1 - bsawwtli2*sawt2 - bsawwtli3*sawt3 - bsawwtli4*sawt4 -bsawwtli5*sawt5
 - bsawwtli6*sawt6 - bsawwtli7*sawt7 - bsawwtli8*sawt8 - bsawwtli9*sawt9 -bsawwtli10*sawt10;

gen dlviw = ln((viw)/(vilagw));

gen dlviwi = ln((viwi)/(vilagw));

gen dlvih = ln((vih) /(vilagh));

gen dlvihi = ln((vihi) /(vilagh));

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-28v2.dta", replace;

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-28v2.dta", clear;

gen sum = dlreihm+dlreiwm;

gen dlvi=dlvih+dlviw;

gen dlvii=dlvihi+dlviwi;

gen dlvi2=ln(vih+viw)-ln(vilagh+vilagw);

gen dlvii2=ln(vihi+viwi)-ln(vilagh+vilagw);

gen wgt=1;

replace wgt=3.35/20 if burvkodu==1|burvkodu==2;

#delimit;

*table 2;

sum reih reiw  childrenw ageh agew vih viw ntrh ntrw tlih tliw [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&dlreihm~=.&dlntrhi~=.&dlntrh~=.;

*table 3;

ivreg  dlreihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);
 
ivreg  dlreihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* industrywd* industryhd* occupwd* occuphd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* industrywd* industryhd* occupwd* occuphd*
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlrtlihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi )   
 ageh agehsq educhd*  agew agewsq educwd* yrd* 
  [aweight=wgt] if lreilagh>0&lreilagw>0&agew<65&ageh<65&(yrd1|yrd2), r cl(bidnr);

ivreg  dlrtliwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi ) 
 ageh agehsq educhd*  agew agewsq educwd* yrd* [aweight=wgt] if lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

gen dlvih2=ln(vih+reiw)-ln(vilagh+reilagw);

gen dlviw2=ln(viw+reih)-ln(vilagw+reilagh);

gen dlvihi2=ln(vihi+reiw)-ln(vilagh+reilagw);

gen dlviwi2=ln(viwi+reih)-ln(vilagw+reilagh);

*table 4;

ivreg  dlreihm (dlntrh dlvish = dlntrhi  dlvishi )   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrw dlvisw= dlntrwi dlviswi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreihm (dlntrh dlvih = dlntrhi  dlvihi ) dlreiw  ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrw dlviw= dlntrwi dlviwi) dlreih ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

*table 5;

ivreg  dlreihm (dlntrh dlntrw dlvih = dlntrhi dlntrwi dlvihi) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlviw = dlntrhi dlntrwi dlviwi) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreihm (dlntrh dlvih = dlntrhi dlvihi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrw dlviw = dlntrwi dlviwi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreihm (dlntrh dlntrw = dlntrhi dlntrwi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw = dlntrhi dlntrwi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

*table 5 columns 7 and 8;

#delimit;

ivreg  dlreihm (dlntrh = dlntrhi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrw = dlntrwi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

*table 6;

ivreg  dlreihm (dlntrh dlntrw dlvi2= dlntrhi dlntrwi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvi2= dlntrhi dlntrwi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreihm (dlntrh dlvih dlviw= dlntrhi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  dlreiwm (dlntrh dlvih dlviw= dlntrhi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  sum (dlntrh dlvih dlviw= dlntrhi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  dlreihm (dlntrh dlvi2= dlntrhi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  dlreiwm (dlntrh dlvi2= dlntrhi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  sum (dlntrh dlvi2= dlntrhi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

 #delimit;
 
*appendix table 1 columns 3 and 4;

ivreg  dlreihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi) dhoush dhousw  ageh agehsq educhd* 
 agew agewsq educwd* yrd* if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi) dhoush dhousw  ageh agehsq educhd* 
 agew agewsq educwd* yrd* if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

*figure 2; 

#delimit cr
 
use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8v2.dta", clear

gen rei88=ei88

gen rei89 = ei89/1.058

gen rei90 = ei90/(1.058*1.064)

gen rei91 = ei91/(1.058*1.064*1.105)

gen lrei91 = ln(rei91+1)

gen lrei90 = ln(rei90+1)

gen lrei89 = ln(rei89+1)

gen lrei88 = ln(rei88+1)

gen dlrei9190 = lrei91-lrei90

gen dlrei9089 = lrei90-lrei89

gen dlrei8988 = lrei89-lrei88

gen rai88= eai88

gen rai89 = eai89w/1.058

gen rai90 = eai90w/(1.058*1.064)

gen rai91 = ai91w/(1.058*1.064*1.105)

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei = int(rai88/100)

replace cei=cei*10

keep if (civ=="07"|civ=="02")&agew<65&agew>18

collapse (mean) dlrei8988 , by(cei)

label variable cei "Real Taxable Income in 1988 (thousands of SEK)"

label variable dlrei8988 "Change in Log Real Earnings from 1988 to 1989"

scatter dlrei8988 cei if cei>50&cei<300, yscale(r(-.2 0)) ylabel(-.2(.1)0, ticks labels)
  
graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph8988all.gph", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei = int(rai89/100)

replace cei=cei*10

keep if (civ=="02"|civ=="07")&agew<65&agew>18

collapse (mean) dlrei9089 , by(cei)

label variable cei "Real Taxable Income in 1989 (thousands of SEK)"

label variable dlrei9089 "Change in Log Real Earnings from 1989 to 1990"

scatter dlrei9089 cei if cei>50&cei<300, yscale(r(-.2 0)) ylabel(-.2(.1)0, ticks labels)

graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph9089all.gph", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei = int(rai90/100)

keep if (civ=="02"|civ=="07")&agew<65&agew>18

collapse (mean) dlrei9190 , by(cei)

replace cei=cei*10

label variable cei "Real Taxable Income in 1990 (thousands of SEK)"

label variable dlrei9190 "Change in Log Real Earnings from 1990 to 1991"

scatter dlrei9190 cei if cei>50&cei<300, yscale(r(-.2 0)) ylabel(-.2(.1)0, ticks labels)

graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph9190all.gph", replace  

*figure 3

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei=int(rai88/100)

keep if (civ=="02")&agew<56

collapse (mean) dlrei8988 dlrei9190 dlntr9190wi, by(cei)

gen test = dlrei9190-dlrei8988

label variable test "Change in Earnings"

label variable dlntr9190wi "Change in NTS"

#delimit;

twoway (connected test cei if cei>5&cei<26, yaxis(2) msymbol(circle) mcolor(black) msize(large)) 
(connected dlntr9190wi cei if cei>5&cei<26, msymbol(square) mcolor(black)), ytitle(Change in NTS) 
yscale(range(.1 .35)) ylabel(.1(.05).35) ylabel(-.3(.05)-.05, axis(2)) xtitle(Base Y) ytitle(Change in Earnings, axis(2));

graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\fig3a.gph", replace;

#delimit cr

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei=int(rai88/100)

keep if (civ=="07")&agew<56

collapse (mean) dlrei8988 dlrei9190 dlntr9190wi , by(cei)

gen test = dlrei9190-dlrei8988

label variable test "Change in Earnings"

label variable dlntr9190wi "Change in NTS"

#delimit;

twoway (connected test cei if cei>4&cei<26, yaxis(2) msymbol(circle) mcolor(black) msize(large)) 
(connected dlntr9190wi cei if cei>4&cei<26, msymbol(square) mcolor(black)), ytitle(Change in NTS) 
yscale(range(.15 .35)) ylabel(.1(.05).35) ylabel(-.15(.05).05, axis(2)) xtitle(Base Y) ytitle(Change in Earnings, axis(2));

graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\fig3b.gph", replace;

#delimit cr

clear

set mem 900m

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8v2.dta", clear

gen vi89wi=.

gen rei88=ei88

gen rei89 = ei89/1.058

gen rei90 = ei90/(1.058*1.064)

gen rei91 = ei91/(1.058*1.064*1.105)

gen rded88=ded88

gen rded89 = ded89/1.058
 
gen rded90 = ded90/(1.058*1.064)

gen rded91 = ded91/(1.058*1.064*1.105)

replace vi89w = vi89w/1.058

replace vi90w = vi90w / (1.058*1.064)

replace vi91w = vi91w/(1.058*1.064*1.105)

replace vi89wi = vi89wi/1.058

replace vi90wi = vi90wi / (1.058*1.064)

replace vi91wi = vi91wi/(1.058*1.064*1.105)

gen lrei91 = ln(rei91)

gen lrei90 = ln(rei90)

gen lrei89 = ln(rei89)

gen lrei88 = ln(rei88)

gen dlrei9190 = lrei91-lrei90

gen dlrei9089 = lrei90-lrei89

gen dlrei8988 = lrei89-lrei88

gen lrai88= ln(eai88)

gen lrai89 = ln((eai89w/1.058))

gen lrai90 = ln((eai90w/(1.058*1.064)))

gen lrai91 = ln(ai91w/((1.058*1.064*1.105)))

gen d = civ=="02"|civ=="07"

#delimit;

keep bidnr burvkodu bidnrh agew agewsq countyw  
educw childrenw selfempw married single
dlrei8988 dlrei9089 dlrei9190 
lrei88 lrei89 lrei90 lrei91 
lrai88 lrai89 lrai90 lrai91 
rei88 rei89 rei90 rei91 
rded88 rded89 rded90 rded91 
dlntr9190w dlntr9089w dlntr8988w 
dlntr9190wi dlntr9089wi dlntr8988wi
vi88w vi89w vi90w vi91w
vi89wi vi90wi vi91wi 
industryw bkon civ occup d
ntr88w ntr89w ntr90w ntr91w
dhous9190w dhous9089w dhous8988w;

stack 
dlntr9190w dlntr9190wi dhous9190w 
dlrei9190 lrei90 lrai90 rei91 rei90 rded91 rded90 vi91w vi90w vi91wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr91w
dlntr9089w dlntr9089wi dhous9089w
dlrei9089 lrei89 lrai89 rei90 rei89 rded90 rded89 vi90w vi89w vi90wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr90w
dlntr8988w dlntr8988wi dhous8988w
dlrei8988 lrei88 lrai88 rei89 rei88 rded89 rded88  vi89w vi88w vi89wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr89w,
into(dlntrw dlntrwi dhousw
dlrei lreilag lrailag rei reilag rded rdedlag viw vilagw viwi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industryw civ d ntrw) clear;

#delimit cr

rename _stack yr

gen gdp=.

tab yr, gen(yrd)

tab countyw, gen(countywd)

rename occup occupw

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-stackv2.dta", replace

keep if civ=="07"

sort bidnrh yr

rename dlrei dlreiw

rename lreilag lreilagw

rename lrailag lrailagw

rename rei reiw

rename reilag reilagw

rename rded rdedw

rename rdedlag rdedlagw

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-wifev2.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-stackv2.dta", clear

keep if civ=="02"

sort bidnrh yr

rename agew ageh

rename agewsq agehsq 

rename dhousw dhoush

rename selfempw selfemph

rename occupw occuph

rename educw educh

rename industryw industryh

rename dlntrw dlntrh 

rename dlntrwi dlntrhi 

rename dlrei dlreih 

rename rded rdedh

rename rdedlag rdedlagh

rename lreilag lreilagh

rename lrailag lrailagh

rename rei reih

rename reilag reilagh

rename viw vih 

rename vilagw vilagh 

rename viwi vihi

rename ntrw ntrh

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-husbv2.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-husbv2.dta", clear

tab occuph, gen(occuphd)

replace industryh=99 if industryh==.

tab industryh, gen(industryhd)

#delimit ;

merge bidnrh yr using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-wifev2.dta"
, keep(agew agewsq educw dlntrw dlntrwi viw vilagw viwi
dlreiw lreilagw lrailagw reiw reilagw industryw selfempw occupw ntrw rdedw rdedlagw dhousw) ;

gen selfempfam = selfemph|selfempw;

keep if _merge==3;

#delimit cr

gen vish = vih+reiw

gen vishi = vihi+reiw

gen visw = viw+reih

gen viswi = viwi+reih

gen vislagh = vilagh+reilagw

gen vislagw = vilagw+reilagh

gen dlvish = ln(vish) - ln(vislagh)

gen dlvisw = ln(visw) - ln(vislagw)

gen dlvishi = ln(vishi) - ln(vislagh)

gen dlviswi = ln(viswi) - ln(vislagw)

tab occupw, gen(occupwd)

tab educw, gen(educwd)

tab educh, gen(educhd)

replace industryw=99 if industryw==.

tab industryw, gen(industrywd)

#delimit;

mkspline sh 10 = lreilagh if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline sw 10 = lreilagw if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline sah 10 = lrailagh if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline saw 10 = lrailagw if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

reg dlreih sh* sw* sah* saw* ageh agehsq educhd* agew agewsq educwd*
 occuphd* occupwd* countywd* if yrd3&lreilagh>0;

matrix Bh = e(b);

#delimit;

matrix Bhshort = Bh["y1", "sh1".."saw10"];

scalar bshh1 = Bhshort[1,1];

scalar bshh2 = Bhshort[1,2];

scalar bshh3 = Bhshort[1,3];

scalar bshh4 = Bhshort[1,4];

scalar bshh5 = Bhshort[1,5];

scalar bshh6 = Bhshort[1,6];

scalar bshh7 = Bhshort[1,7];

scalar bshh8 = Bhshort[1,8];

scalar bshh9 = Bhshort[1,9];

scalar bshh10 = Bhshort[1,10];

scalar bshw1 = Bhshort[1,11];

scalar bshw2 = Bhshort[1,12];

scalar bshw3 = Bhshort[1,13];

scalar bshw4 = Bhshort[1,14];

scalar bshw5 = Bhshort[1,15];

scalar bshw6 = Bhshort[1,16];

scalar bshw7 = Bhshort[1,17];

scalar bshw8 = Bhshort[1,18];

scalar bshw9 = Bhshort[1,19];

scalar bshw10 = Bhshort[1,20];

scalar bsahh1 = Bhshort[1,21];

scalar bsahh2 = Bhshort[1,22];

scalar bsahh3 = Bhshort[1,23];

scalar bsahh4 = Bhshort[1,24];

scalar bsahh5 = Bhshort[1,25];

scalar bsahh6 = Bhshort[1,26];

scalar bsahh7 = Bhshort[1,27];

scalar bsahh8 = Bhshort[1,28];

scalar bsahh9 = Bhshort[1,29];

scalar bsahh10 = Bhshort[1,30];

scalar bsahw1 = Bhshort[1,31];

scalar bsahw2 = Bhshort[1,32];

scalar bsahw3 = Bhshort[1,33];

scalar bsahw4 = Bhshort[1,34];

scalar bsahw5 = Bhshort[1,35];

scalar bsahw6 = Bhshort[1,36];

scalar bsahw7 = Bhshort[1,37];

scalar bsahw8 = Bhshort[1,38];

scalar bsahw9 = Bhshort[1,39];

scalar bsahw10 = Bhshort[1,40];

reg dlreiw sh* sw* sah* saw* ageh agehsq educhd* agew agewsq educwd* 
 occuphd* occupwd* countywd*  if yrd3&lreilagw>0;

matrix Bw = e(b);

matrix Bwshort = Bw["y1", "sh1".."saw10"];

scalar bswh1 = Bwshort[1,1];

scalar bswh2 = Bwshort[1,2];

scalar bswh3 = Bwshort[1,3];

scalar bswh4 = Bwshort[1,4];

scalar bswh5 = Bwshort[1,5];

scalar bswh6 = Bwshort[1,6];

scalar bswh7 = Bwshort[1,7];

scalar bswh8 = Bwshort[1,8];

scalar bswh9 = Bwshort[1,9];

scalar bswh10 = Bwshort[1,10];

scalar bsww1 = Bwshort[1,11];

scalar bsww2 = Bwshort[1,12];

scalar bsww3 = Bwshort[1,13];

scalar bsww4 = Bwshort[1,14];

scalar bsww5 = Bwshort[1,15];

scalar bsww6 = Bwshort[1,16];

scalar bsww7 = Bwshort[1,17];

scalar bsww8 = Bwshort[1,18];

scalar bsww9 = Bwshort[1,19];

scalar bsww10 = Bwshort[1,20];

scalar bsawh1 = Bwshort[1,21];

scalar bsawh2 = Bwshort[1,22];

scalar bsawh3 = Bwshort[1,23];

scalar bsawh4 = Bwshort[1,24];

scalar bsawh5 = Bwshort[1,25];

scalar bsawh6 = Bwshort[1,26];

scalar bsawh7 = Bwshort[1,27];

scalar bsawh8 = Bwshort[1,28];

scalar bsawh9 = Bwshort[1,29];

scalar bsawh10 = Bwshort[1,30];

scalar bsaww1 = Bwshort[1,31];

scalar bsaww2 = Bwshort[1,32];

scalar bsaww3 = Bwshort[1,33];

scalar bsaww4 = Bwshort[1,34];

scalar bsaww5 = Bwshort[1,35];

scalar bsaww6 = Bwshort[1,36];

scalar bsaww7 = Bwshort[1,37];

scalar bsaww8 = Bwshort[1,38];

scalar bsaww9 = Bwshort[1,39];

scalar bsaww10 = Bwshort[1,40];

drop sh* sw* sah* saw*;

mkspline sh 10 = lreilagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline sw 10 = lreilagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline sah 10 = lrailagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline saw 10 = lrailagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

gen dlreihm = dlreih - bshh1*sh1 - bshh2*sh2 - bshh3*sh3 - bshh4*sh4 -bshh5*sh5
- bshh6*sh6 - bshh6*sh6 - bshh7*sh7 - bshh8*sh8 - bshh9*sh9 - bshh10*sh10 
- bshw1*sw1 - bshw2*sw2 - bshw3*sw3 - bshw4*sw4 -bshw5*sw5
- bshw6*sw6 - bshw7*sw7 - bshw8*sw8 - bshw9*sw9 -bshw10*sw10
- bsahh1*sah1 - bsahh2*sah2 - bsahh3*sah3 - bsahh4*sah4 -bsahh5*sah5
- bsahh6*sah6 - bsahh7*sah7 - bsahh8*sah8 - bsahh9*sah9 -bsahh10*sah10
- bsahw1*saw1 - bsahw2*saw2 - bsahw3*saw3 - bsahw4*saw4 -bsahw5*saw5
- bsahw6*saw6 - bsahw7*saw7 - bsahw8*saw8 - bsahw9*saw9 -bsahw10*saw10;

gen dlreiwm = dlreiw - bswh1*sh1 - bswh2*sh2 - bswh3*sh3 - bswh4*sh4 -bswh5*sh5
- bswh6*sh6 - bswh6*sh6 - bswh7*sh7 - bswh8*sh8 - bswh9*sh9 - bswh10*sh10 
- bsww1*sw1 - bsww2*sw2 - bsww3*sw3 - bsww4*sw4 -bsww5*sw5
- bsww6*sw6 - bsww7*sw7 - bsww8*sw8 - bsww9*sw9 -bsww10*sw10
- bsawh1*sah1 - bsawh2*sah2 - bsawh3*sah3 - bsawh4*sah4 -bsawh5*sah5
- bsawh6*sah6 - bsawh7*sah7 - bsawh8*sah8 - bsawh9*sah9 -bsawh10*sah10
- bsaww1*saw1 - bsaww2*saw2 - bsaww3*saw3 - bsaww4*saw4 -bsaww5*saw5
- bsaww6*saw6 - bsaww7*saw7 - bsaww8*saw8 - bsaww9*saw9 -bsaww10*saw10;

 gen tlih = max(reih-rdedh,0);

 gen tliw = max(reiw-rdedw,0);

 gen tlilagh = max(reilagh-rdedlagh,0);

 gen tlilagw = max(reilagw-rdedlagw,0);

 gen lrtlilagh = ln(tlilagh);

 gen lrtlilagw = ln(tlilagw);

 gen dlrtlih = ln(tlih) - ln(tlilagh);

 gen dlrtliw = ln(tliw) - ln(tlilagw);

 mkspline shtli 10 = lrtlilagh if lreilagh>0&lreilagw>0&agew<65& 
ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline swtli 10 = lrtlilagw if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline sahtli 10 = lrailagh if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline sawtli 10 = lrailagw if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 reg dlrtlih shtli* swtli* sahtli* sawtli* ageh agehsq educhd* agew agewsq educwd*
  occuphd* occupwd* countywd* if yrd3&lreilagh>0;

 matrix Bhtli = e(b);

 matrix Bhshorttli = Bhtli["y1", "shtli1".."sawtli10"];

 scalar bshhtli1 = Bhshorttli[1,1];

 scalar bshhtli2 = Bhshorttli[1,2];

 scalar bshhtli3 = Bhshorttli[1,3];

 scalar bshhtli4 = Bhshorttli[1,4];

 scalar bshhtli5 = Bhshorttli[1,5];

 scalar bshhtli6 = Bhshorttli[1,6];

 scalar bshhtli7 = Bhshorttli[1,7];

 scalar bshhtli8 = Bhshorttli[1,8];

 scalar bshhtli9 = Bhshorttli[1,9];

 scalar bshhtli10 = Bhshorttli[1,10];

 scalar bshwtli1 = Bhshorttli[1,11];

 scalar bshwtli2 = Bhshorttli[1,12];

 scalar bshwtli3 = Bhshorttli[1,13];

 scalar bshwtli4 = Bhshorttli[1,14];

 scalar bshwtli5 = Bhshorttli[1,15];

 scalar bshwtli6 = Bhshorttli[1,16];

 scalar bshwtli7 = Bhshorttli[1,17];

 scalar bshwtli8 = Bhshorttli[1,18];

 scalar bshwtli9 = Bhshorttli[1,19];

 scalar bshwtli10 = Bhshorttli[1,20];

 scalar bsahhtli1 = Bhshorttli[1,21];

 scalar bsahhtli2 = Bhshorttli[1,22];

 scalar bsahhtli3 = Bhshorttli[1,23];

 scalar bsahhtli4 = Bhshorttli[1,24];

 scalar bsahhtli5 = Bhshorttli[1,25];

 scalar bsahhtli6 = Bhshorttli[1,26];

 scalar bsahhtli7 = Bhshorttli[1,27];

 scalar bsahhtli8 = Bhshorttli[1,28];

 scalar bsahhtli9 = Bhshorttli[1,29];

 scalar bsahhtli10 = Bhshorttli[1,30];

 scalar bsahwtli1 = Bhshorttli[1,31];

 scalar bsahwtli2 = Bhshorttli[1,32];

 scalar bsahwtli3 = Bhshorttli[1,33];

 scalar bsahwtli4 = Bhshorttli[1,34];

 scalar bsahwtli5 = Bhshorttli[1,35];

 scalar bsahwtli6 = Bhshorttli[1,36];

 scalar bsahwtli7 = Bhshorttli[1,37];

 scalar bsahwtli8 = Bhshorttli[1,38];

 scalar bsahwtli9 = Bhshorttli[1,39];

 scalar bsahwtli10 = Bhshorttli[1,40];

 reg dlrtliw shtli* swtli* sahtli* sawtli* ageh agehsq educhd* agew agewsq educwd* 
  occuphd* occupwd* countywd*  if yrd3&lreilagw>0;

 matrix Bwtli = e(b);

 matrix Bwshorttli = Bwtli["y1", "shtli1".."sawtli10"];

 scalar bswhtli1 = Bwshorttli[1,1];

 scalar bswhtli2 = Bwshorttli[1,2];

 scalar bswhtli3 = Bwshorttli[1,3];

 scalar bswhtli4 = Bwshorttli[1,4];

 scalar bswhtli5 = Bwshorttli[1,5];

 scalar bswhtli6 = Bwshorttli[1,6];

 scalar bswhtli7 = Bwshorttli[1,7];

 scalar bswhtli8 = Bwshorttli[1,8];

 scalar bswhtli9 = Bwshorttli[1,9];

 scalar bswhtli10 = Bwshorttli[1,10];

 scalar bswwtli1 = Bwshorttli[1,11];

 scalar bswwtli2 = Bwshorttli[1,12];

 scalar bswwtli3 = Bwshorttli[1,13];

 scalar bswwtli4 = Bwshorttli[1,14];

 scalar bswwtli5 = Bwshorttli[1,15];

 scalar bswwtli6 = Bwshorttli[1,16];

 scalar bswwtli7 = Bwshorttli[1,17];

 scalar bswwtli8 = Bwshorttli[1,18];

 scalar bswwtli9 = Bwshorttli[1,19];

 scalar bswwtli10 =Bwshorttli[1,20];

 scalar bsawhtli1 = Bwshorttli[1,21];

 scalar bsawhtli2 = Bwshorttli[1,22];

 scalar bsawhtli3 = Bwshorttli[1,23];

 scalar bsawhtli4 = Bwshorttli[1,24];

 scalar bsawhtli5 = Bwshorttli[1,25];

 scalar bsawhtli6 = Bwshorttli[1,26];

 scalar bsawhtli7 = Bwshorttli[1,27];

 scalar bsawhtli8 = Bwshorttli[1,28];

 scalar bsawhtli9 = Bwshorttli[1,29];

 scalar bsawhtli10 =Bwshorttli[1,30];

 scalar bsawwtli1 = Bwshorttli[1,31];

 scalar bsawwtli2 = Bwshorttli[1,32];

 scalar bsawwtli3 = Bwshorttli[1,33];

 scalar bsawwtli4 = Bwshorttli[1,34];

 scalar bsawwtli5 = Bwshorttli[1,35];

 scalar bsawwtli6 = Bwshorttli[1,36];

 scalar bsawwtli7 = Bwshorttli[1,37];

 scalar bsawwtli8 = Bwshorttli[1,38];

 scalar bsawwtli9 = Bwshorttli[1,39];

 scalar bsawwtli10 = Bwshorttli[1,40];

 drop shtli* swtli* sahtli* sawtli*;

 mkspline sht 10 = lrtlilagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline swt 10 = lrtlilagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline saht 10 = lrailagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline sawt 10 = lrailagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 gen dlrtlihm = dlrtlih - bshhtli1*sht1 - bshhtli2*sht2 - bshhtli3*sht3 - bshhtli4*sht4 -bshhtli5*sht5
 - bshhtli6*sht6 - bshhtli6*sht6 - bshhtli7*sht7 - bshhtli8*sht8 - bshhtli9*sht9 - bshhtli10*sht10 
 - bshwtli1*swt1 - bshwtli2*swt2 - bshwtli3*swt3 - bshwtli4*swt4 -bshwtli5*swt5
 - bshwtli6*swt6 - bshwtli7*swt7 - bshwtli8*swt8 - bshwtli9*swt9 -bshwtli10*swt10
 - bsahhtli1*saht1 - bsahhtli2*saht2 - bsahhtli3*saht3 - bsahhtli4*saht4 -bsahhtli5*saht5
 - bsahhtli6*saht6 - bsahhtli7*saht7 - bsahhtli8*saht8 - bsahhtli9*saht9 -bsahhtli10*saht10
 - bsahwtli1*sawt1 - bsahwtli2*sawt2 - bsahwtli3*sawt3 - bsahwtli4*sawt4 -bsahwtli5*sawt5
 - bsahwtli6*sawt6 - bsahwtli7*sawt7 - bsahwtli8*sawt8 - bsahwtli9*sawt9 -bsahwtli10*sawt10;

 gen dlrtliwm = dlrtliw - bswhtli1*sht1 - bswhtli2*sht2 - bswhtli3*sht3 - bswhtli4*sht4 -bswhtli5*sht5
 - bswhtli6*sht6 - bswhtli6*sht6 - bswhtli7*sht7 - bswhtli8*sht8 - bswhtli9*sht9 - bswhtli10*sht10 
 - bswwtli1*swt1 - bswwtli2*swt2 - bswwtli3*swt3 - bswwtli4*swt4 -bswwtli5*swt5
 - bswwtli6*swt6 - bswwtli7*swt7 - bswwtli8*swt8 - bswwtli9*swt9 -bswwtli10*swt10
 - bsawhtli1*saht1 - bsawhtli2*saht2 - bsawhtli3*saht3 - bsawhtli4*saht4 -bsawhtli5*saht5
 - bsawhtli6*saht6 - bsawhtli7*saht7 - bsawhtli8*saht8 - bsawhtli9*saht9 -bsawhtli10*saht10
 - bsawwtli1*sawt1 - bsawwtli2*sawt2 - bsawwtli3*sawt3 - bsawwtli4*sawt4 -bsawwtli5*sawt5
 - bsawwtli6*sawt6 - bsawwtli7*sawt7 - bsawwtli8*sawt8 - bsawwtli9*sawt9 -bsawwtli10*sawt10;

gen dlviw = ln((viw)/(vilagw));

gen dlviwi = ln((viwi)/(vilagw));

gen dlvih = ln((vih) /(vilagh));

gen dlvihi = ln((vihi) /(vilagh));

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-28v2.dta", replace;

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-28v2.dta", clear;

gen sum = dlreihm+dlreiwm;

gen dlvi=dlvih+dlviw;

gen dlvii=dlvihi+dlviwi;

gen dlvi2=ln(vih+viw)-ln(vilagh+vilagw);

gen dlvii2=ln(vihi+viwi)-ln(vilagh+vilagw);

gen wgt=1;

replace wgt=3.35/20 if burvkodu==1|burvkodu==2;

*table 3 (note: first two regressions are columns 3-4 of table 3);

ivreg  dlreihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);
 
ivreg  dlreihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* industrywd* industryhd* occupwd* occuphd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* industrywd* industryhd* occupwd* occuphd*
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlrtlihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi )   
 ageh agehsq educhd*  agew agewsq educwd* yrd* 
  [aweight=wgt] if lreilagh>0&lreilagw>0&agew<65&ageh<65&(yrd1|yrd2), r cl(bidnr);

ivreg  dlrtliwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi ) 
 ageh agehsq educhd*  agew agewsq educwd* yrd* [aweight=wgt] if lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

gen dlvih2=ln(vih+reiw)-ln(vilagh+reilagw);

gen dlviw2=ln(viw+reih)-ln(vilagw+reilagh);

gen dlvihi2=ln(vihi+reiw)-ln(vilagh+reilagw);

gen dlviwi2=ln(viwi+reih)-ln(vilagw+reilagh);

#delimit;

*table 4 (note: the first two regressions are columns 5-6 of appendix table 1);

ivreg  dlreihm (dlntrh dlvish = dlntrhi  dlvishi )   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrw dlvisw= dlntrwi dlviswi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreihm (dlntrh dlvih = dlntrhi  dlvihi ) dlreiw  ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrw dlviw= dlntrwi dlviwi) dlreih ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

*table 5;

ivreg  dlreihm (dlntrh dlntrw dlvih = dlntrhi dlntrwi dlvihi) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlviw = dlntrhi dlntrwi dlviwi) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreihm (dlntrh dlvih = dlntrhi dlvihi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrw dlviw = dlntrwi dlviwi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreihm (dlntrh dlntrw = dlntrhi dlntrwi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw = dlntrhi dlntrwi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

*table 5 columns 7 and 8;

#delimit;

ivreg  dlreihm (dlntrh = dlntrhi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrw = dlntrwi ) ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt]  if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

*table 6;

ivreg  dlreihm (dlntrh dlntrw dlvi2= dlntrhi dlntrwi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvi2= dlntrhi dlntrwi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreihm (dlntrh dlvih dlviw= dlntrhi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  dlreiwm (dlntrh dlvih dlviw= dlntrhi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  sum (dlntrh dlvih dlviw= dlntrhi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  dlreihm (dlntrh dlvi2= dlntrhi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  dlreiwm (dlntrh dlvi2= dlntrhi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

ivreg  sum (dlntrh dlvi2= dlntrhi dlvii2)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* 
 [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65&(dlntrhi ==dlntrwi), r cl(bidnr);

*appendix table 1 columns 3 and 4, done without adding 1 to earnings;

ivreg  dlreihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi) dhoush dhousw  ageh agehsq educhd* 
 agew agewsq educwd* yrd* if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi) dhoush dhousw  ageh agehsq educhd* 
 agew agewsq educwd* yrd* if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

#delimit cr
 
use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8v2.dta", clear

gen rei88=ei88

gen rei89 = ei89/1.058

gen rei90 = ei90/(1.058*1.064)

gen rei91 = ei91/(1.058*1.064*1.105)

gen lrei91 = ln(rei91)

gen lrei90 = ln(rei90)

gen lrei89 = ln(rei89)

gen lrei88 = ln(rei88)

gen dlrei9190 = lrei91-lrei90

gen dlrei9089 = lrei90-lrei89

gen dlrei8988 = lrei89-lrei88

gen rai88= eai88

gen rai89 = eai89w/1.058

gen rai90 = eai90w/(1.058*1.064)

gen rai91 = ai91w/(1.058*1.064*1.105)

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei = int(rai88/100)

replace cei=cei*10

keep if (civ=="07"|civ=="02")&agew<65&agew>18

collapse (mean) dlrei8988 , by(cei)

label variable cei "Real Taxable Income in 1988 (thousands of SEK)"

label variable dlrei8988 "Change in Log Real Earnings from 1988 to 1989"

scatter dlrei8988 cei if cei>50&cei<300, yscale(r(-.2 0)) ylabel(-.2(.1)0, ticks labels)
  
graph save  "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph8988allno1.gph", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei = int(rai89/100)

replace cei=cei*10

keep if (civ=="02"|civ=="07")&agew<65&agew>18

collapse (mean) dlrei9089 , by(cei)

label variable cei "Real Taxable Income in 1989 (thousands of SEK)"

label variable dlrei9089 "Change in Log Real Earnings from 1989 to 1990"

scatter dlrei9089 cei if cei>50&cei<300, yscale(r(-.2 0)) ylabel(-.2(.1)0, ticks labels)

graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph9089allno1.gph", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei = int(rai90/100)

keep if (civ=="02"|civ=="07")&agew<65&agew>18

collapse (mean) dlrei9190 , by(cei)

replace cei=cei*10

label variable cei "Real Taxable Income in 1990 (thousands of SEK)"

label variable dlrei9190 "Change in Log Real Earnings from 1990 to 1991"

scatter dlrei9190 cei if cei>50&cei<300, yscale(r(-.2 0)) ylabel(-.2(.1)0, ticks labels)

graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph9190allno1.gph", replace  

*figure 3

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei=int(rai88/100)

keep if (civ=="02")&agew<56

collapse (mean) dlrei8988 dlrei9190 dlntr9190wi, by(cei)

gen test = dlrei9190-dlrei8988

label variable test "Change in Earnings"

label variable dlntr9190wi "Change in NTS"

#delimit;

twoway (connected test cei if cei>5&cei<26, yaxis(2) msymbol(circle) mcolor(black) msize(large)) 
(connected dlntr9190wi cei if cei>5&cei<26, msymbol(square) mcolor(black)), ytitle(Change in NTS) 
yscale(range(.1 .35)) ylabel(.1(.05).35) ylabel(-.3(.05)-.05, axis(2)) xtitle(Base Y) ytitle(Change in Earnings, axis(2));

graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\fig3ano1.gph", replace;

#delimit cr

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\graph091711.dta", clear

gen cei=int(rai88/100)

keep if (civ=="07")&agew<56

collapse (mean) dlrei8988 dlrei9190 dlntr9190wi , by(cei)

gen test = dlrei9190-dlrei8988

label variable test "Change in Earnings"

label variable dlntr9190wi "Change in NTS"

#delimit;

twoway (connected test cei if cei>4&cei<26, yaxis(2) msymbol(circle) mcolor(black) msize(large)) 
(connected dlntr9190wi cei if cei>4&cei<26, msymbol(square) mcolor(black)), ytitle(Change in NTS) 
yscale(range(.15 .35)) ylabel(.1(.05).35) ylabel(-.15(.05).05, axis(2)) xtitle(Base Y) ytitle(Change in Earnings, axis(2));

graph save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\fig3bno1.gph", replace;

#delimit cr
  
clear

set mem 900m

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8v2.dta", clear

gen vi89wi=.

gen rei88=ei88

gen rei89 = ei89/1.058

gen rei90 = ei90/(1.058*1.064)

gen rei91 = ei91/(1.058*1.064*1.105)

gen rded88=ded88

gen rded89 = ded89/1.058
 
gen rded90 = ded90/(1.058*1.064)

gen rded91 = ded91/(1.058*1.064*1.105)

replace vi89w = vi89w/1.058

replace vi90w = vi90w / (1.058*1.064)

replace vi91w = vi91w/(1.058*1.064*1.105)

replace vi89wi = vi89wi/1.058

replace vi90wi = vi90wi / (1.058*1.064)

replace vi91wi = vi91wi/(1.058*1.064*1.105)

gen lrei91 = ln(rei91+.5)

gen lrei90 = ln(rei90+.5)

gen lrei89 = ln(rei89+.5)

gen lrei88 = ln(rei88+.5)

gen dlrei9190 = lrei91-lrei90

gen dlrei9089 = lrei90-lrei89

gen dlrei8988 = lrei89-lrei88

gen lrai88= ln(eai88+1)

gen lrai89 = ln((eai89w/1.058)+.5)

gen lrai90 = ln((eai90w/(1.058*1.064))+.5)

gen lrai91 = ln(ai91w/((1.058*1.064*1.105))+.5)

gen d = civ=="02"|civ=="07"

#delimit;

keep bidnr burvkodu bidnrh agew agewsq countyw  
educw childrenw selfempw married single
dlrei8988 dlrei9089 dlrei9190 
lrei88 lrei89 lrei90 lrei91 
lrai88 lrai89 lrai90 lrai91 
rei88 rei89 rei90 rei91 
rded88 rded89 rded90 rded91 
dlntr9190w dlntr9089w dlntr8988w 
dlntr9190wi dlntr9089wi dlntr8988wi
vi88w vi89w vi90w vi91w
vi89wi vi90wi vi91wi 
industryw bkon civ occup d
ntr88w ntr89w ntr90w ntr91w;

stack 
dlntr9190w dlntr9190wi
dlrei9190 lrei90 lrai90 rei91 rei90 rded91 rded90 vi91w vi90w vi91wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr91w
dlntr9089w dlntr9089wi
dlrei9089 lrei89 lrai89 rei90 rei89 rded90 rded89 vi90w vi89w vi90wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr90w
dlntr8988w dlntr8988wi
dlrei8988 lrei88 lrai88 rei89 rei88 rded89 rded88  vi89w vi88w vi89wi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industry civ d ntr89w,
into(dlntrw dlntrwi 
dlrei lreilag lrailag rei reilag rded rdedlag viw vilagw viwi
bidnr  bidnrh burvkodu agew agewsq countyw selfempw occup
educw childrenw industryw civ d ntrw) clear;

#delimit cr

rename _stack yr

gen gdp=.

tab yr, gen(yrd)

tab countyw, gen(countywd)

rename occup occupw

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-stackv2.dta", replace

keep if civ=="07"

sort bidnrh yr

rename dlrei dlreiw

rename lreilag lreilagw

rename lrailag lrailagw

rename rei reiw

rename reilag reilagw

rename rded rdedw

rename rdedlag rdedlagw

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-wifev2.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-stackv2.dta", clear

keep if civ=="02"

sort bidnrh yr

rename agew ageh

rename agewsq agehsq 

rename selfempw selfemph

rename occupw occuph

rename educw educh

rename industryw industryh

rename dlntrw dlntrh 

rename dlntrwi dlntrhi 

rename dlrei dlreih 

rename rded rdedh

rename rdedlag rdedlagh

rename lreilag lreilagh

rename lrailag lrailagh

rename rei reih

rename reilag reilagh

rename viw vih 

rename vilagw vilagh 

rename viwi vihi

rename ntrw ntrh

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-husbv2.dta", replace

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-husbv2.dta", clear

tab occuph, gen(occuphd)

replace industryh=99 if industryh==.

tab industryh, gen(industryhd)

#delimit ;

merge bidnrh yr using "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-8-wifev2.dta"
, keep(agew agewsq educw dlntrw dlntrwi viw vilagw viwi
dlreiw lreilagw lrailagw reiw reilagw industryw selfempw occupw ntrw rdedw rdedlagw) ;

gen selfempfam = selfemph|selfempw;

keep if _merge==3;

#delimit cr

gen vish = vih+reiw

gen vishi = vihi+reiw

gen visw = viw+reih

gen viswi = viwi+reih

gen vislagh = vilagh+reilagw

gen vislagw = vilagw+reilagh

gen dlvish = ln(vish) - ln(vislagh)

gen dlvisw = ln(visw) - ln(vislagw)

gen dlvishi = ln(vishi) - ln(vislagh)

gen dlviswi = ln(viswi) - ln(vislagw)

tab occupw, gen(occupwd)

tab educw, gen(educwd)

tab educh, gen(educhd)

replace industryw=99 if industryw==.

tab industryw, gen(industrywd)

#delimit;

mkspline sh 10 = lreilagh if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline sw 10 = lreilagw if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline sah 10 = lrailagh if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

mkspline saw 10 = lrailagw if ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3;

reg dlreih sh* sw* sah* saw* ageh agehsq educhd* agew agewsq educwd*
 occuphd* occupwd* countywd* if yrd3&lreilagh>0;

matrix Bh = e(b);

#delimit;

matrix Bhshort = Bh["y1", "sh1".."saw10"];

scalar bshh1 = Bhshort[1,1];

scalar bshh2 = Bhshort[1,2];

scalar bshh3 = Bhshort[1,3];

scalar bshh4 = Bhshort[1,4];

scalar bshh5 = Bhshort[1,5];

scalar bshh6 = Bhshort[1,6];

scalar bshh7 = Bhshort[1,7];

scalar bshh8 = Bhshort[1,8];

scalar bshh9 = Bhshort[1,9];

scalar bshh10 = Bhshort[1,10];

scalar bshw1 = Bhshort[1,11];

scalar bshw2 = Bhshort[1,12];

scalar bshw3 = Bhshort[1,13];

scalar bshw4 = Bhshort[1,14];

scalar bshw5 = Bhshort[1,15];

scalar bshw6 = Bhshort[1,16];

scalar bshw7 = Bhshort[1,17];

scalar bshw8 = Bhshort[1,18];

scalar bshw9 = Bhshort[1,19];

scalar bshw10 = Bhshort[1,20];

scalar bsahh1 = Bhshort[1,21];

scalar bsahh2 = Bhshort[1,22];

scalar bsahh3 = Bhshort[1,23];

scalar bsahh4 = Bhshort[1,24];

scalar bsahh5 = Bhshort[1,25];

scalar bsahh6 = Bhshort[1,26];

scalar bsahh7 = Bhshort[1,27];

scalar bsahh8 = Bhshort[1,28];

scalar bsahh9 = Bhshort[1,29];

scalar bsahh10 = Bhshort[1,30];

scalar bsahw1 = Bhshort[1,31];

scalar bsahw2 = Bhshort[1,32];

scalar bsahw3 = Bhshort[1,33];

scalar bsahw4 = Bhshort[1,34];

scalar bsahw5 = Bhshort[1,35];

scalar bsahw6 = Bhshort[1,36];

scalar bsahw7 = Bhshort[1,37];

scalar bsahw8 = Bhshort[1,38];

scalar bsahw9 = Bhshort[1,39];

scalar bsahw10 = Bhshort[1,40];

reg dlreiw sh* sw* sah* saw* ageh agehsq educhd* agew agewsq educwd* 
 occuphd* occupwd* countywd*  if yrd3&lreilagw>0;

matrix Bw = e(b);

matrix Bwshort = Bw["y1", "sh1".."saw10"];

scalar bswh1 = Bwshort[1,1];

scalar bswh2 = Bwshort[1,2];

scalar bswh3 = Bwshort[1,3];

scalar bswh4 = Bwshort[1,4];

scalar bswh5 = Bwshort[1,5];

scalar bswh6 = Bwshort[1,6];

scalar bswh7 = Bwshort[1,7];

scalar bswh8 = Bwshort[1,8];

scalar bswh9 = Bwshort[1,9];

scalar bswh10 = Bwshort[1,10];

scalar bsww1 = Bwshort[1,11];

scalar bsww2 = Bwshort[1,12];

scalar bsww3 = Bwshort[1,13];

scalar bsww4 = Bwshort[1,14];

scalar bsww5 = Bwshort[1,15];

scalar bsww6 = Bwshort[1,16];
scalar bsww7 = Bwshort[1,17];
scalar bsww8 = Bwshort[1,18];
scalar bsww9 = Bwshort[1,19];
scalar bsww10 = Bwshort[1,20];

scalar bsawh1 = Bwshort[1,21];

scalar bsawh2 = Bwshort[1,22];

scalar bsawh3 = Bwshort[1,23];

scalar bsawh4 = Bwshort[1,24];

scalar bsawh5 = Bwshort[1,25];

scalar bsawh6 = Bwshort[1,26];

scalar bsawh7 = Bwshort[1,27];

scalar bsawh8 = Bwshort[1,28];

scalar bsawh9 = Bwshort[1,29];

scalar bsawh10 = Bwshort[1,30];

scalar bsaww1 = Bwshort[1,31];

scalar bsaww2 = Bwshort[1,32];

scalar bsaww3 = Bwshort[1,33];

scalar bsaww4 = Bwshort[1,34];

scalar bsaww5 = Bwshort[1,35];

scalar bsaww6 = Bwshort[1,36];

scalar bsaww7 = Bwshort[1,37];

scalar bsaww8 = Bwshort[1,38];

scalar bsaww9 = Bwshort[1,39];

scalar bsaww10 = Bwshort[1,40];

drop sh* sw* sah* saw*;

mkspline sh 10 = lreilagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline sw 10 = lreilagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline sah 10 = lrailagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

mkspline saw 10 = lrailagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
&(yrd1|yrd2)&lreilagh>0&lreilagw>0;

gen dlreihm = dlreih - bshh1*sh1 - bshh2*sh2 - bshh3*sh3 - bshh4*sh4 -bshh5*sh5
- bshh6*sh6 - bshh6*sh6 - bshh7*sh7 - bshh8*sh8 - bshh9*sh9 - bshh10*sh10 
- bshw1*sw1 - bshw2*sw2 - bshw3*sw3 - bshw4*sw4 -bshw5*sw5
- bshw6*sw6 - bshw7*sw7 - bshw8*sw8 - bshw9*sw9 -bshw10*sw10
- bsahh1*sah1 - bsahh2*sah2 - bsahh3*sah3 - bsahh4*sah4 -bsahh5*sah5
- bsahh6*sah6 - bsahh7*sah7 - bsahh8*sah8 - bsahh9*sah9 -bsahh10*sah10
- bsahw1*saw1 - bsahw2*saw2 - bsahw3*saw3 - bsahw4*saw4 -bsahw5*saw5
- bsahw6*saw6 - bsahw7*saw7 - bsahw8*saw8 - bsahw9*saw9 -bsahw10*saw10;

gen dlreiwm = dlreiw - bswh1*sh1 - bswh2*sh2 - bswh3*sh3 - bswh4*sh4 -bswh5*sh5
- bswh6*sh6 - bswh6*sh6 - bswh7*sh7 - bswh8*sh8 - bswh9*sh9 - bswh10*sh10 
- bsww1*sw1 - bsww2*sw2 - bsww3*sw3 - bsww4*sw4 -bsww5*sw5
- bsww6*sw6 - bsww7*sw7 - bsww8*sw8 - bsww9*sw9 -bsww10*sw10
- bsawh1*sah1 - bsawh2*sah2 - bsawh3*sah3 - bsawh4*sah4 -bsawh5*sah5
- bsawh6*sah6 - bsawh7*sah7 - bsawh8*sah8 - bsawh9*sah9 -bsawh10*sah10
- bsaww1*saw1 - bsaww2*saw2 - bsaww3*saw3 - bsaww4*saw4 -bsaww5*saw5
- bsaww6*saw6 - bsaww7*saw7 - bsaww8*saw8 - bsaww9*saw9 -bsaww10*saw10;

 gen tlih = max(reih-rdedh,0);

 gen tliw = max(reiw-rdedw,0);

 gen tlilagh = max(reilagh-rdedlagh,0);

 gen tlilagw = max(reilagw-rdedlagw,0);

 gen lrtlilagh = ln(tlilagh+1);

 gen lrtlilagw = ln(tlilagw+1);

 gen dlrtlih = ln(tlih+1) - ln(tlilagh+1);

 gen dlrtliw = ln(tliw+1) - ln(tlilagw+1);

 mkspline shtli 10 = lrtlilagh if lreilagh>0&lreilagw>0&agew<65& 
ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline swtli 10 = lrtlilagw if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline sahtli 10 = lrailagh if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 mkspline sawtli 10 = lrailagw if lreilagh>0&lreilagw>0&agew<65&
 ageh<65&(civ=="02"|civ=="07")&selfempfam==0&yrd3&lrtlilagh~=.;

 reg dlrtlih shtli* swtli* sahtli* sawtli* ageh agehsq educhd* agew agewsq educwd*
  occuphd* occupwd* countywd* if yrd3&lreilagh>0;

 matrix Bhtli = e(b);

 matrix Bhshorttli = Bhtli["y1", "shtli1".."sawtli10"];

 scalar bshhtli1 = Bhshorttli[1,1];

 scalar bshhtli2 = Bhshorttli[1,2];

 scalar bshhtli3 = Bhshorttli[1,3];

 scalar bshhtli4 = Bhshorttli[1,4];

 scalar bshhtli5 = Bhshorttli[1,5];

 scalar bshhtli6 = Bhshorttli[1,6];

 scalar bshhtli7 = Bhshorttli[1,7];

 scalar bshhtli8 = Bhshorttli[1,8];

 scalar bshhtli9 = Bhshorttli[1,9];

 scalar bshhtli10 = Bhshorttli[1,10];

 scalar bshwtli1 = Bhshorttli[1,11];

 scalar bshwtli2 = Bhshorttli[1,12];

 scalar bshwtli3 = Bhshorttli[1,13];

 scalar bshwtli4 = Bhshorttli[1,14];

 scalar bshwtli5 = Bhshorttli[1,15];

 scalar bshwtli6 = Bhshorttli[1,16];

 scalar bshwtli7 = Bhshorttli[1,17];

 scalar bshwtli8 = Bhshorttli[1,18];

 scalar bshwtli9 = Bhshorttli[1,19];

 scalar bshwtli10 = Bhshorttli[1,20];

 scalar bsahhtli1 = Bhshorttli[1,21];

 scalar bsahhtli2 = Bhshorttli[1,22];

 scalar bsahhtli3 = Bhshorttli[1,23];

 scalar bsahhtli4 = Bhshorttli[1,24];

 scalar bsahhtli5 = Bhshorttli[1,25];

 scalar bsahhtli6 = Bhshorttli[1,26];

 scalar bsahhtli7 = Bhshorttli[1,27];

 scalar bsahhtli8 = Bhshorttli[1,28];

 scalar bsahhtli9 = Bhshorttli[1,29];

 scalar bsahhtli10 = Bhshorttli[1,30];

 scalar bsahwtli1 = Bhshorttli[1,31];

 scalar bsahwtli2 = Bhshorttli[1,32];

 scalar bsahwtli3 = Bhshorttli[1,33];

 scalar bsahwtli4 = Bhshorttli[1,34];

 scalar bsahwtli5 = Bhshorttli[1,35];

 scalar bsahwtli6 = Bhshorttli[1,36];

 scalar bsahwtli7 = Bhshorttli[1,37];

 scalar bsahwtli8 = Bhshorttli[1,38];

 scalar bsahwtli9 = Bhshorttli[1,39];

 scalar bsahwtli10 = Bhshorttli[1,40];

 reg dlrtliw shtli* swtli* sahtli* sawtli* ageh agehsq educhd* agew agewsq educwd* 
  occuphd* occupwd* countywd*  if yrd3&lreilagw>0;

 matrix Bwtli = e(b);

 matrix Bwshorttli = Bwtli["y1", "shtli1".."sawtli10"];

 scalar bswhtli1 = Bwshorttli[1,1];

 scalar bswhtli2 = Bwshorttli[1,2];

 scalar bswhtli3 = Bwshorttli[1,3];

 scalar bswhtli4 = Bwshorttli[1,4];

 scalar bswhtli5 = Bwshorttli[1,5];

 scalar bswhtli6 = Bwshorttli[1,6];

 scalar bswhtli7 = Bwshorttli[1,7];

 scalar bswhtli8 = Bwshorttli[1,8];

 scalar bswhtli9 = Bwshorttli[1,9];

 scalar bswhtli10 = Bwshorttli[1,10];

 scalar bswwtli1 = Bwshorttli[1,11];

 scalar bswwtli2 = Bwshorttli[1,12];

 scalar bswwtli3 = Bwshorttli[1,13];

 scalar bswwtli4 = Bwshorttli[1,14];

 scalar bswwtli5 = Bwshorttli[1,15];

 scalar bswwtli6 = Bwshorttli[1,16];

 scalar bswwtli7 = Bwshorttli[1,17];

 scalar bswwtli8 = Bwshorttli[1,18];

 scalar bswwtli9 = Bwshorttli[1,19];

 scalar bswwtli10 =Bwshorttli[1,20];

 scalar bsawhtli1 = Bwshorttli[1,21];

 scalar bsawhtli2 = Bwshorttli[1,22];

 scalar bsawhtli3 = Bwshorttli[1,23];

 scalar bsawhtli4 = Bwshorttli[1,24];

 scalar bsawhtli5 = Bwshorttli[1,25];

 scalar bsawhtli6 = Bwshorttli[1,26];

 scalar bsawhtli7 = Bwshorttli[1,27];

 scalar bsawhtli8 = Bwshorttli[1,28];

 scalar bsawhtli9 = Bwshorttli[1,29];

 scalar bsawhtli10 =Bwshorttli[1,30];

 scalar bsawwtli1 = Bwshorttli[1,31];

 scalar bsawwtli2 = Bwshorttli[1,32];

 scalar bsawwtli3 = Bwshorttli[1,33];

 scalar bsawwtli4 = Bwshorttli[1,34];

 scalar bsawwtli5 = Bwshorttli[1,35];

 scalar bsawwtli6 = Bwshorttli[1,36];

 scalar bsawwtli7 = Bwshorttli[1,37];

 scalar bsawwtli8 = Bwshorttli[1,38];

 scalar bsawwtli9 = Bwshorttli[1,39];

 scalar bsawwtli10 = Bwshorttli[1,40];

 drop shtli* swtli* sahtli* sawtli*;

 mkspline sht 10 = lrtlilagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline swt 10 = lrtlilagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline saht 10 = lrailagh if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 mkspline sawt 10 = lrailagw if agew<65&ageh<65&(civ=="02"|civ=="07")&selfempfam==0
 &(yrd1|yrd2)&lreilagh>0&lreilagw>0&lrtlilagh~=.;

 gen dlrtlihm = dlrtlih - bshhtli1*sht1 - bshhtli2*sht2 - bshhtli3*sht3 - bshhtli4*sht4 -bshhtli5*sht5
 - bshhtli6*sht6 - bshhtli6*sht6 - bshhtli7*sht7 - bshhtli8*sht8 - bshhtli9*sht9 - bshhtli10*sht10 
 - bshwtli1*swt1 - bshwtli2*swt2 - bshwtli3*swt3 - bshwtli4*swt4 -bshwtli5*swt5
 - bshwtli6*swt6 - bshwtli7*swt7 - bshwtli8*swt8 - bshwtli9*swt9 -bshwtli10*swt10
 - bsahhtli1*saht1 - bsahhtli2*saht2 - bsahhtli3*saht3 - bsahhtli4*saht4 -bsahhtli5*saht5
 - bsahhtli6*saht6 - bsahhtli7*saht7 - bsahhtli8*saht8 - bsahhtli9*saht9 -bsahhtli10*saht10
 - bsahwtli1*sawt1 - bsahwtli2*sawt2 - bsahwtli3*sawt3 - bsahwtli4*sawt4 -bsahwtli5*sawt5
 - bsahwtli6*sawt6 - bsahwtli7*sawt7 - bsahwtli8*sawt8 - bsahwtli9*sawt9 -bsahwtli10*sawt10;

 gen dlrtliwm = dlrtliw - bswhtli1*sht1 - bswhtli2*sht2 - bswhtli3*sht3 - bswhtli4*sht4 -bswhtli5*sht5
 - bswhtli6*sht6 - bswhtli6*sht6 - bswhtli7*sht7 - bswhtli8*sht8 - bswhtli9*sht9 - bswhtli10*sht10 
 - bswwtli1*swt1 - bswwtli2*swt2 - bswwtli3*swt3 - bswwtli4*swt4 -bswwtli5*swt5
 - bswwtli6*swt6 - bswwtli7*swt7 - bswwtli8*swt8 - bswwtli9*swt9 -bswwtli10*swt10
 - bsawhtli1*saht1 - bsawhtli2*saht2 - bsawhtli3*saht3 - bsawhtli4*saht4 -bsawhtli5*saht5
 - bsawhtli6*saht6 - bsawhtli7*saht7 - bsawhtli8*saht8 - bsawhtli9*saht9 -bsawhtli10*saht10
 - bsawwtli1*sawt1 - bsawwtli2*sawt2 - bsawwtli3*sawt3 - bsawwtli4*sawt4 -bsawwtli5*sawt5
 - bsawwtli6*sawt6 - bsawwtli7*sawt7 - bsawwtli8*sawt8 - bsawwtli9*sawt9 -bsawwtli10*sawt10;

gen dlviw = ln((viw)/(vilagw));

gen dlviwi = ln((viwi)/(vilagw));

gen dlvih = ln((vih) /(vilagh));

gen dlvihi = ln((vihi) /(vilagh));

save "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-28v2.dta", replace;

use "\\Mfso01\MyDocs\gelal\My Documents\My SAS Files\9-28v2.dta", clear;

gen sum = dlreihm+dlreiwm;

gen dlvi=dlvih+dlviw;

gen dlvii=dlvihi+dlviwi;

gen dlvi2=ln(vih+viw)-ln(vilagh+vilagw);

gen dlvii2=ln(vihi+viwi)-ln(vilagh+vilagw);

gen wgt=1;

replace wgt=3.35/20 if burvkodu==1|burvkodu==2;

*table 3 (same as appendix table 1 columns 1 and 2);

ivreg  dlreihm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);

ivreg  dlreiwm (dlntrh dlntrw dlvih dlviw= dlntrhi dlntrwi dlvihi dlviwi)   ageh agehsq educhd* 
 agew agewsq educwd* yrd* [aweight=wgt] if (yrd1|yrd2)&lreilagh>0&lreilagw>0&agew<65&ageh<65, r cl(bidnr);
 
log close;
