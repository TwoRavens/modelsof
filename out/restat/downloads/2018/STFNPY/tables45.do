clear

/* creates tables 4 and 5*/

global o "se bracket noaster label nocons"
global x "black white hisp somefree alwaysfree male_ride"
global yob "yob5-yob17"
global birthmiss "bw momlths momhs momcoll married momage bo bwmiss momedumiss marriedmiss bomiss momagemiss"
global lead "gmean"
global birth "bw momlths momhs momcoll married momage bo"
global num "numinfract_yr"
global birthmomfe "momage married bo bw"
global birthnobw "momlths momhs momcoll married momage bo"
global cl "robust"


/* measurement error*/

global extras "test_result* lead_date* address_id*"

use pid approxdob $extras avglevel leadcapil leadvenous new_school_id3 firstfips mother_id race mom_race black white hisp asian somefree alwaysfree male_ride gestat $birthmiss $lead anyinfract numinfract suspendout numyears_inf read_score* neverfree suspendout yob* tr bl firsttract avg50 birth_year using temp_add.dta

drop if birth_year<1990
drop if birth_year>2004

gen numinfract_yrs=numinfract/numyears_inf
gen anysuspend=suspendout>0 & suspendout~=. 
label var numinfract_yrs "Number of infractions/year"
label var anysuspend "Any suspension"

gen leadmale=gmean*male_ride
label var leadmale "Lead*male"

replace race=mom_race if race==5 & mom_race~=. 

cap drop _merge
gen tract2010=substr(firsttract, 1,11)
sort tract2010

merge tract2010 using tractmuni_xwalk.dta
egen muni_code=group(muni_name)

gen momid=real(mother_id)
sort momid approxdob
by momid: egen avglead=mean($lead)
by momid: gen kidnum=_n
by momid: gen numkids=kidnum[_N]
replace avglead=. if momid==.
replace kidnum=. if momid==.
replace numkids=. if momid==.

gen sibavg=(avglead*numkids-$lead)/(numkids-1) if momid~=. & numkids>=2
label var sibavg "Sibling lead"
corr $lead sibavg

gen sibavgm=sibavg*male_ride

qui do "$drive\dofiles\arg\random.do"

keep if birth_year<=2004
drop if numyears_inf==0
count

global l1 "leadfirst"
global l2 "leadsecond"

gen r=runiform()

gen r1=$l1 if r<0.5
replace r1=$l2 if r>=.5

gen r2=$l1 if r>=.5
replace r2=$l2 if r<.5

label var r1 "Random draw 1"
label var r2 "Random draw 2"

global l1 "random1"
global l2 "randomnot1"
set more off
gen blacktime=black*(birth_year-1987)
gen paidtime=neverfree*(birth_year-1987)
label var blacktime "Black*year of birth"
label var paidtime "Paid lunch*year of birth"

gen blacktime2=black*(birth_year-1987)^2
gen paidtime2=neverfree*(birth_year-1987)^2
label var blacktime2 "Black*year of birth squared"
label var paidtime2 "Paid lunch*year of birth squared"

cap drop _merge
sort pid
merge pid using allcrime.dta
tab _merge
drop if _merge==2
replace ridoc=0 if _merge==1
replace rits=0 if _merge==1
replace anyarrest=0 if _merge==1
replace anycrime=0 if _merge==1

gen ridoc2=ridoc
replace ridoc2=1 if rits==1
replace ridoc2=. if birth_year<1991 | birth_year>1999
table birth_year, c(mean ridoc2)
table birth_year if male_ride==1, c(mean ridoc2)
global time "yob1-yob17 blacktime* paidtime*"

replace anysuspend=. if birth_year>=2005 | birth_year<1989


replace male=male_ride
gen leadcapilm=male*leadcapil
label var leadcapilm "Capilary lead*male"
gen leadvenousm=leadvenous*male
label var leadvenousm "Venous lead*male"

gen random1m=male*random1
gen randomnot1m=male*randomnot1
label var random1m "First random*male"
label var randomnot1m "Avg all other tests*male"

global l1 "random1 random1m"
global l2 "randomnot1 randomnot1m"
global xcrime "male_ride black white hisp somefree alwaysfree"
global leadm "gmean leadmale"

/* make sure the sample is the same*/

/* generate the traffic measure*/

cap drop _merge
sort pid
merge pid using less_add_newroads.dta
tab _merge

gen rural=0
replace rural=1 if muni_code==3
replace rural=1 if muni_code==5
replace rural=1 if muni_code==12
replace rural=1 if muni_code==13
replace rural=1 if muni_code==14
replace rural=1 if muni_code==15
replace rural=1 if muni_code==11
replace rural=1 if muni_code==6
replace rural=1 if muni_code==21
replace rural=1 if muni_code==18
replace rural=1 if muni_code==27
replace rural=1 if muni_code==30
replace rural=1 if muni_code==33
replace rural=1 if muni_code==37
replace rural=1 if muni_code==39

tab rural 

global vmt "1"

gen vmt_pri=3327/$vmt if rural==0
gen vmt_sec=572/$vmt if rural==0
gen vmt_ter=146/$vmt if rural==0
replace vmt_pri=1031/$vmt if rural==1
replace vmt_sec=132/$vmt if rural==1
replace vmt_ter=19/$vmt if rural==1

destring firstfips,replace

gen multiplier=.735 if firstfips==1 & rural==0
replace multiplier=.623 if firstfips==3 & rural==0
replace multiplier=.692 if firstfips==5 & rural==0
replace multiplier=1.257 if firstfips==7 & rural==0
replace multiplier=.509 if firstfips==9 & rural==0
replace multiplier=0.48 if rural==1

local x=25
while `x'<=50 {

gen avg`x'_123=avg_pri`x'*vmt_pri+avg_sec`x'*vmt_sec + avg_ter`x'*vmt_ter
local x=`x'+25
}


gen traffic2=avg25_123+(avg50_123-avg25_123)*.25

global traffic "traffic2"
gen lntraffic=ln($traffic)

gen lntrafficyob=lntraffic*(birth_year-1987)
global iv "lntrafficyob"


egen x=rownonmiss($traffic anysuspend numyears_inf $lead black hisp white neverfree male_ride birth_year bl)
tab x


keep if x==11

/* table 5 measurement error table*/

foreach y in anysuspend {

global t "$results\me_`y'.xls"

iis bl

areg `y' gmean leadmale $x $time i.numyears_inf if leadvenous~=. & leadcapil~=., a(bl) $cl
outreg2 using $t,replace $o keep(gmean leadmale) addtext (FE, Block Group) cti(FE) sortvar(leadcapil leadvenous $l1 $l2) ti(Table 5: Exploring Bias from Measurement Error Exploiting Multiple Measures of Lead)
areg `y' leadcapil* $x $time i.numyears_inf if leadvenous~=., a(bl) $cl
outreg2 using $t,append $o keep(leadcapil*) addtext (FE, Block Group) cti(FE) sortvar(leadcapil leadvenous $l1 $l2)
areg `y' leadvenous* $x $time i.numyears_inf if leadcapil~=., a(bl) $cl
outreg2 using $t,append $o keep(leadvenous*) addtext (FE, Block Group) cti(FE)sortvar(leadcapil leadvenous $l1 $l2)
xtivreg `y' (leadcapil*=leadvenous*) $x $time i.numyears_inf, fe first
outreg2 using $t,append $o keep(leadcapil*) addtext (FE, Block Group) cti(IV-FE) sortvar(leadcapil leadvenous $l1 $l2)
xtivreg `y' (leadvenous*=leadcapil*) $x $time i.numyears_inf, fe first
outreg2 using $t,append $o keep(leadvenous*) addtext (FE, Block Group) cti(IV-FE) sortvar(gmean leadmale leadcapil leadvenous $l1 $l2)


areg `y' gmean leadmale $x  $time i.numyears_inf if randomnot1~=., a(bl) $cl
outreg2 using $t,append $o keep(gmean leadmale) cti(FE) sortvar(leadcapil leadvenous $l1 $l2)
areg `y' $l1 $x  $time i.numyears_inf if randomnot1~=., a(bl) $cl
outreg2 using $t,append $o keep($l1) cti(FE) sortvar(leadcapil leadvenous $l1 $l2)
areg `y' $l2 $x $time i.numyears_inf if random1~=., a(bl) $cl
outreg2 using $t,append $o keep($l2) cti(FE) sortvar(leadcapil leadvenous $l1 $l2)
xtivreg `y' ($l1=$l2) $x $time i.numyears_inf, fe first
outreg2 using $t,append $o keep($l1) cti(FE-IV) sortvar(leadcapil leadvenous $l1 $l2)
xtivreg `y' ($l2=$l1) $x $time i.numyears_inf, fe first
outreg2 using $t,append $o keep($l2) cti(FE-IV) sortvar(leadcapil leadvenous $l1 $l2)
xtivreg `y' ($leadm=sibavg sibavgm) $x $time i.numyears_inf, fe first
outreg2 using $t,append $o keep($leadm) cti(FE-IV) sortvar(gmean leadmale leadcapil leadvenous $l1 $l2)
}




drop if numyears_inf==0 | anysuspend==. 
replace numkids=. if momid==. 
gen sibsample=1 if numkids>=2 & numkids~=. 
replace sibsample=. if momid==. 

/*Table 4*/
global y "anysuspend"
global birth "momlths momhs momcoll married momage bo bw"
global birthmomfe "married momage bo bw"
global l1 "random1 random1m"
global l2 "randomnot1 randomnot1m"
global t "$results\newmain_inter.xls"

areg $y $leadm $x $time,a(bl) $cl
outreg2 using $t, replace $o keep($leadm $x) cti(OLS) addtext(Measure of lead, geometic mean, Birth cohorts, 1990-2004, Sample, All children, Fixed effect, block group, Instrument, none)

areg $y $leadm male_ride $birth $x $time i.numyears_inf if sibsample==1,a(bl) $cl
outreg2 using $t, append $o cti(OLS) keep($leadm male_ride $x $birth) addtext(Measure of lead, geometric mean, Birth cohorts, 1997-2004, Sample, Siblings, Fixed effect, block group, Instrument, none)

areg $y $leadm male_ride $birthmomfe $time i.numyears_inf if sibsample==1,a(momid) $cl
outreg2 using $t, append $o cti(Sibling FE) keep($leadm male_ride $birthmomfe) addtext(Measure of lead, geometric mean, Birth cohorts, 1997-2004, Sample, Siblings, Fixed effect, sibling, Instrument, none)

areg $y $l1 $x  $time i.numyears_inf, a(bl) $cl
outreg2 using $t,append keep($l1 $x) cti(OLS) $o ti("Table 4: Comparing Estimates that Address Bias from Omitted Variables and Measurement Error") addtext(Measure of lead, single draw, Birth cohorts, 1990-2004, Sample, all children,Fixed effect, block group, Instrument, none)

areg $y $l1 $x  $time i.numyears_inf if randomnot1~=., a(bl) $cl
outreg2 using $t,append keep($l1 $x) cti(OLS) $o  addtext(Measure of lead, single draw, Birth cohorts, 1990-2004, Sample, Children with>1 BLL,Fixed effect, block group, Instrument, none)

iis bl
xtivreg $y ($l1=$l2) $x $time i.numyears_inf, fe first
outreg2 using $t, append $o keep($l1 $x) cti(IV) sortvar($leadm $l1 male_ride $x $birthmomfe) addtext(Measure of lead, single draw, Birth cohorts, 1990-2004, Sample, children with >1 BLL,Fixed effect, block group, Instrument, other draw)

cap drop yhat yhatmale
areg $lead lntrafficyob lntraffic $x $time i.numyears_inf, a(bl)
predict yhat
gen yhatmale=yhat*male_ride

xtivreg $y ($leadm=lntrafficyob yhatmale) lntraffic $x $time i.numyears_inf, fe first
outreg2 using $t, append $o keep($leadm $x) cti(IV) sortvar($leadm $l1 male_ride $x $birthmomfe) addtext(Measure of lead, geometric mean, Birth cohorts, 1990-2004, Sample, All children,Fixed effect, block group, Instrument, traffic*year of birth)



local x=1
while `x'<=18 {
gen blackyob`x'=black*yob`x'
local x=`x'+1
}

local x=1
while `x'<=18 {
gen neveryob`x'=neverfree*yob`x'
local x=`x'+1
}


local x=1
while `x'<=18 {
gen hispyob`x'=hisp*yob`x'
local x=`x'+1
}

global time12 "yob1-yob12 blackyob1-blackyob12 neveryob1-neveryob12"

/* table 4 - delinquency results*/

global t "$results\newmain_inter_crime.xls"

global y "ridoc2"

areg $y $leadm $xcrime $time12,a(bl) $cl
outreg2 using $t, replace $o keep($leadm $x) cti(OLS) addtext(Measure of lead, geometic mean, Birth cohorts, 1991-1997, Sample, all children, Fixed effect, block group, Instrument, none)

areg $y $l1 $xcrime  $time12, a(bl) $cl
outreg2 using $t,append keep($l1 $xcrime) $o cti(OLS) addtext(Measure of lead, single draw, Birth cohorts, 1991-1997, Sample, all children, Fixed effect, block group, Instrument, none)

areg $y $l1 $xcrime  $time12 if randomnot1~=., a(bl) $cl
outreg2 using $t,append keep($l1 $xcrime) $o cti(OLS) addtext(Measure of lead, single draw, Birth cohorts, 1991-1997, Sample, children with >1 BLL, Fixed effect, block group, Instrument, none)

iis bl
xtivreg $y ($l1=$l2) $xcrime $time12, fe first
outreg2 using $t, append $o keep($l1 $x) cti(IV) sortvar($leadm $l1 male_ride $xcrime) addtext(Measure of lead, single draw, Birth cohorts, 1991-1997, Sample, children with >1 BLL, Fixed effect, block group, Instrument, other draw)

cap drop yhat yhatmale
areg $lead lntrafficyob lntraffic $x $time, a(bl)
predict yhat
gen yhatmale=yhat*male_ride

xtivreg $y ($leadm=lntrafficyob yhatmale) lntraffic $xcrime $time12, fe first
outreg2 using $t, append $o keep($leadm $x) cti(IV) sortvar($leadm $l1 male_ride $xcrime) addtext(Measure of lead, single draw, Birth cohorts, 1991-1997, Sample, all children, Fixed effect, block group, Instrument, traffic*year of birth)



/* table 5*/

foreach y in ridoc2 {

global t "$results\me_`y'.xls"

iis bl
areg `y' gmean leadmale $xcrime $time12 if leadvenous~=. & leadcapil~=., a(bl) $cl
outreg2 using $t,replace $o keep(gmean leadmale) addtext (FE, Block Group) cti(FE) sortvar(leadcapil* leadvenous* $l1 $l2) ti(Measurement Error in Lead & Future Detention/Incarceration)
areg `y' leadcapil* $xcrime $time12 if leadvenous~=., a(bl) $cl
outreg2 using $t,append $o keep(leadcapil*) addtext (FE, Block Group) cti(FE) sortvar(leadcapil* leadvenous* $l1 $l2) ti(Measurement Error in Lead & Future Detention/Incarceration)
areg `y' leadvenous* $xcrime $time12 if leadcapil~=., a(bl) $cl
outreg2 using $t,append $o keep(leadvenous*) addtext (FE, Block Group) cti(FE)sortvar(leadcapil* leadvenous* $l1 $l2)
xtivreg `y' (leadcapil*=leadvenous*) $xcrime $time , fe first
outreg2 using $t,append $o keep(leadcapil*) addtext (FE, Block Group) cti(IV-FE) sortvar(leadcapil* leadvenous* $l1 $l2)
xtivreg `y' (leadvenous*=leadcapil*) $xcrime $time , fe first
outreg2 using $t,append $o keep(leadvenous*) addtext (FE, Block Group) cti(IV-FE) sortvar(leadcapil* leadvenous* $l1 $l2)


areg `y' gmean leadmale $xcrime  $time12 if randomnot1~=., a(bl) $cl
outreg2 using $t,append $o keep(gmean leadmale) cti(FE) sortvar(gmean leadmale leadcapil* leadvenous $l1 $l2)
areg `y' $l1 $xcrime  $time12 if randomnot1~=., a(bl) $cl
outreg2 using $t,append $o keep($l1) cti(FE) sortvar(gmean leadmale leadcapil* leadvenous $l1 $l2)
areg `y' $l2 $xcrime $time12 if random1~=., a(bl) $cl
outreg2 using $t,append $o keep($l2) cti(FE) sortvar(gmean leadmale leadcapil* leadvenous $l1 $l2)
xtivreg `y' ($l1=$l2) $xcrime $time12, fe first
outreg2 using $t,append $o keep($l1) cti(FE-IV) sortvar(gmean leadmale leadcapil* leadvenous $l1 $l2)
xtivreg `y' ($l2=$l1) $xcrime $time12, fe first
outreg2 using $t,append $o keep($l2) cti(FE-IV) sortvar(gmean leadmale leadcapil* leadvenous* $l1 $l2)


}

