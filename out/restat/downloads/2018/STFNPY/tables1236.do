 
set more off
set emptycells drop
set matsize 1000

/* this program generates tables 1, 2, 3 and 6 as well as appendix tables 1,2 and 3*/


global o "se bracket noaster label nocons"
global x "black white hisp somefree alwaysfree male_ride i.numyears_inf"
global yob "yob5-yob17"
global birthmiss "bw momlths momhs momcoll married momage bo bwmiss momedumiss marriedmiss bomiss momagemiss"
global lead "gmean"
global birth "bw momlths momhs momcoll married momage bo"
global num "numinfract_yr"
global birthmomfe "momage married bo bw"
global birthnobw "momlths momhs momcoll married momage bo"
global cl "robust"
global sample "keep if birth_year<2005 & birth_year>=1990"
global tl "1990"
global th "2004"


clear
use pid new_school_id* test_result* vtest_result* ctest_result* numinfract* firstfips mother_id race mom_race black white hisp asian other somefree alwaysfree male_ride gestat $birthmiss $lead anyinfract numinfract* numyears_inf read_score* neverfree suspendout yob* tr bl firsttract avg50 birth_year approxdob firstaddress approxdob using temp_add.dta

/* merge with new roads & lead data*/

sort pid
merge pid using less_add_newroads.dta
tab _merge
keep if _merge==3
drop _merge

/* generate variables*/

replace asian=1 if other==1
label var asian "Asian or other"

egen sumtests=rowmiss(test_result*)
replace sumtests=73-sumtests

egen sumvtests=rowmiss(vtest_result*)
egen sumctests=rowmiss(ctest_result*)
replace sumvtests=73-sumvtests
replace sumctests=73-sumctests
label var sumtests "Total number of lead tests"
label var sumctests "Number of capillary tests"
label var sumvtests "Number of venous tests"

drop vtest_result* ctest_result*

gen anysuspend=suspendout~=0 if suspendout~=.
label var anysuspend "Any out of school suspension"
summ anyinfract anysuspend

tab numyears_inf
replace anysuspend=. if numyears_inf==0 | numyears_inf==. 

$sample 
drop if anysuspend==. | numyears_inf==0


gen numinfract_yr=numinfract/numyears_inf
summ numinfract numinfract_yr anyinfract, det
label var numinfract_yr "Infractions/year"

replace race=mom_race if race==5 & mom_race~=. 


/* merge municipalities on*/

cap drop _merge
gen tract2010=substr(firsttract, 1,11)
sort tract2010

merge tract2010 using tractmuni_xwalk.dta
egen muni_code=group(muni_name)

/* define areas as rural*/

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

/* generate the traffic measure*/

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

/* sample selection*/

egen x=rownonmiss($traffic anysuspend numyears_inf $lead black hisp white neverfree male_ride birth_year bl)
tab x

keep if x==11


/* make more variables*/

gen paid=0
replace paid=1 if neverfree==0 & somefree==0

gen leadbl=black*$lead
gen leadpoor=(1-neverfree)*$lead
gen leadhisp=hisp*$lead
label var leadbl "Lead*African American"
label var leadpoor "Lead*Free Lunch"
label var leadhisp "Lead*Hispanic"

replace male=male_ride


gen leadmale=$lead*male_ride
label var leadmale "Lead*male"


gen blacktime=black*(birth_year-1987)
gen paidtime=neverfree*(birth_year-1987)
gen sometime=somefree*(birth_year-1987)
gen alltime=alwaysfree*(birth_year-1987)

label var blacktime "Black*year of birth"
label var paidtime "Paid lunch*year of birth"
label var sometime "Sometimes free lunch*year of birth"
label var alltime "Always free lunch*year of birth"


gen blacktime2=blacktime^2
gen paidtime2=paidtime^2
gen alltime2=alltime^2
gen sometime2=sometime^2

label var blacktime2 "Black*year of birth squared"
label var paidtime2 "Paid lunch*year of birth squared"

label var alltime2 "Always free lunch*year of birth squared"
label var sometime2 "Sometimes free lunch*year of birth squared"


gen midschoolid=new_school_id6
replace midschoolid=new_school_id7 if midschoolid==. 
replace midschoolid=new_school_id8 if midschoolid==. 

gen schoolid=midschoolid
replace schoolid=new_school_id9 if schoolid==. 
replace schoolid=new_school_id10 if schoolid==. 
replace schoolid=new_school_id11 if schoolid==. 
replace schoolid=new_school_id5 if schoolid==. 
replace schoolid=new_school_id4 if schoolid==. 
replace schoolid=new_school_id3 if schoolid==. 


gen lunch=1 if neverfree==1
replace lunch=2 if somefree==1
replace lunch=3 if alwaysfree==1


gen sharecapil=sumctests/sumtests


gen momid=real(mother_id)
drop if numyears_inf==0 | anysuspend==. 

sort momid birth_year
by momid: gen kidnum=_n if momid~=.
by momid: gen numkids=kidnum[_N] if momid~=.
replace numkids=. if momid==. 
tab numkids
gen sibsample=1 if numkids>=2 & numkids~=. 
tab sibsample

/* drop unnecessary variables*/

drop addid* primary* secondary* tertiary* roadlength* addid* lead_date* lead_geo* geo_2010*  rd50*


/* Trends over time*/


table birth_year if birth_year==$tl | birth_year==$th, c (mean anyinfract mean anysuspend mean $num mean $lead)

table birth_year neverfree if birth_year==$tl | birth_year==$th, c (mean anyinfract mean anysuspend mean $num mean $lead)

table birth_year race if birth_year==$tl | birth_year==$th, c (mean anyinfract mean anysuspend mean $num mean $lead)

table birth_year, c (mean $lead mean anysuspend mean numinfract9 mean numinfract7)

/* table 1  means*/

summ $lead sumtests sharecapil anyinfract numyears_inf anysuspend black white hisp asian somefree alwaysfree male_ride $birth 
summ $lead sumtests sharecapil anyinfract anysuspend numyears_inf anysuspend black white hisp asian somefree alwaysfree male_ride $birth if white==1
summ $lead sumtests sharecapil anyinfract anysuspend numyears_inf anysuspend black white hisp asian somefree alwaysfree male_ride $birth if black==1
summ $lead sumtests sharecapil anyinfract anysuspend numyears_inf anysuspend black white hisp asian somefree alwaysfree male_ride $birth if hisp==1
summ $lead sumtests sharecapil anyinfract anysuspend numyears_inf anysuspend black white hisp asian somefree alwaysfree male_ride $birth if neverfree==0
summ $lead sumtests sharecapil anyinfract anysuspend numyears_inf anysuspend black white hisp asian somefree alwaysfree male_ride $birth if neverfree==1
summ $lead sumtests sharecapil anyinfract anysuspend numyears_inf anysuspend black white hisp asian somefree alwaysfree male_ride $birth if birth_year>=1997
summ $lead sumtests sharecapil anyinfract anysuspend numyears_inf anysuspend black white hisp asian somefree alwaysfree male_ride $birth if sibsample==1

/* table 2 Road Density and Child Disadvantage*/

egen median50=median($traffic)
egen pct75=pctile($traffic), p(75)
egen pct25=pctile($traffic), p(25)

gen high50=$traffic>=median50
gen high25=1 if $traffic>=pct75 & $traffic~=. 
replace high25=0 if $traffic<=pct25
tab high25
label var high25 "High Traffic (Top Quartile)"


global t "$results\table2.xls"

reg white high25
outreg2 using $t,replace se bracket noaster label ti("Table 2: Road Density and Child Advantage") cti(State)
areg white high25, a(muni_code)
outreg2 using $t,append se bracket noaster label cti(Municipality)
areg white high25, a(tr)
outreg2 using $t,append se bracket noaster label cti(Tract)
areg white high25, a(bl)
outreg2 using $t,append se bracket noaster label cti(Block Group)

reg neverfree high25
outreg2 using $t,append se bracket noaster label cti(State)
areg neverfree high25, a(muni_code)
outreg2 using $t,append se bracket noaster label cti(Municipality)
areg neverfree high25, a(tr)
outreg2 using $t,append se bracket noaster label cti(Tract)
areg neverfree high25, a(bl)
outreg2 using $t,append se bracket noaster label cti(Block Group)




/* OLS with  lots of controls  Table 3 */

global lead "gmean"
global xkeep "black white hisp somefree alwaysfree male_ride blacktime* paidtime*"
global time "yob1-yob17 blacktime* paidtime*"

global y "anysuspend"

global t "$results\table3ols.xls"


areg $y $lead male_ride i.birth_year i.numyears_inf, a(muni_code) 
outreg2 using $t,replace $o keep($lead male_ride) addtext(FE, Municipality, Birth cohorts, 1990-2004) cti(FE) ti("Table 3: Ordinary Least Squares Effects of Lead on the Probability of Suspension and Detention")

areg $y $lead $x $time ,a(bl)
outreg2 using $t,append $o keep($lead $xkeep) sortvar($lead leadmale male_ride $xkeep bw $birth) addtext(FE, Block Group, Birth cohorts, 1990-2004) cti(Any Suspension)

xi: areg $y $lead $x $time i.schoolid, a(bl)
outreg2 using $t,append $o keep($lead $xkeep) sortvar($lead leadmale male_ride $xkeep bw $birth) addtext(FE, Block Group & school, Birth cohorts, 1990-2004) 


areg $y $lead $x $time if birth_year>=1997 & bw~=.,a(bl)
outreg2 using $t,append $o keep($lead $xkeep) sortvar($lead leadmale male_ride $xkeep) addtext(FE, Block Group, Birth cohorts, 1997-2004) 

estimates store H1

areg $y $lead $x $time $birth bw if birth_year>=1997,a(bl)
outreg2 using $t,append $o keep($lead $xkeep $birth bw) sortvar($lead leadmale male_ride $xkeep bw $birth) addtext(FE, Block Group, Birth cohorts, 1997-2004) addnote("All regressions include cohort FE and controls for number of years with infraction data.")

estimates store H2

test [H1_$lead=H2_$lead]


areg $y $lead leadmale $x $time ,a(bl)
outreg2 using $t,append $o keep($lead leadmale $xkeep) sortvar($lead leadmale male_ride $xkeep bw $birth) addtext(FE, Block Group, Birth cohorts, 1990-2004) 

estimates store H3


/* movers vs. nonmovers among sibglings*/

gen sameblock=0 if sibsample==1

sort momid pid
by momid: replace sameblock=1 if $traffic==$traffic[_n-1] & sibsample==1
by momid: replace sameblock=1 if $traffic==$traffic[_n+1] & sibsample==1

tab sameblock

sort momid pid
by momid: egen mnmale=mean(male)
gen allfemale=mnmale==0 if sibsample==1
gen allmale=mnmale==1 if sibsample==1

global timefe "yob10-yob17 blacktime paidtime"

/* first stage - Table 6*/

gen lntraffic=ln($traffic)
gen lntrafficyob=lntraffic*(birth_year-1987)
label var lntraffic "Ln(traffic)"
label var lntrafficyob "Ln(traffic)*time trend"


global xkeep "black white hisp somefree alwaysfree male_ride"
global time "yob1-yob17 blacktime* paidtime*"

global t "$results\first.xls"
global iv "lntrafficyob"

iis bl
areg $lead $iv lntraffic $x $time,a(bl) $cl
outreg2 using $t,replace keep($iv lntraffic $xkeep) ti("Table 6: First Stage Regression Estimates") $o addnote("All regressions include full set of controls included in the third column of Table 3. See equation (2) in text.")

predict e, resid

cap drop yhat yhatmale
predict yhat
gen yhatmale=yhat*male
label var yhatmale "Predicted lead*male"

areg leadmale yhatmale lntraffic $iv $x $time, a(bl) $cl
outreg2 using $t,append keep($iv yhatmale lntraffic $xkeep) $o

predict emale,resid


/* appendix table 3*/

global t "$results\ref1check.xls"


global timecheck "$time"

global o "se bracket noaster label nocons sdec(7)"
areg black $iv lntraffic male somefree alwaysfree $timecheck i.numyears, a(bl) $cl
outreg2 using $t,replace keep($iv) $o 
areg neverfree $iv lntraffic male black hisp white $timecheck i.numyears, a(bl) $cl
outreg2 using $t,append keep($iv) $o 
areg alwaysfree $iv lntraffic male black hisp white $timecheck i.numyears, a(bl) $cl
outreg2 using $t,append keep($iv) $o 
areg somefree $iv lntraffic male black hisp white $timecheck i.numyears, a(bl) $cl
outreg2 using $t,append keep($iv) $o 


/* bw regressions - Appendix table 2*/
global leadm "gmean leadmale"

global t "$results\bw.xls"

iis bl
areg bw lntraffic $iv $x $time $birthnobw if birth_year>=1997,a(bl) $cl
outreg2 using $t,replace drop($time) sortvar($lead leadmale $iv lntraffic $x $birthnobw) $o ti("Appendix Table 2: Birth Weight, Lead and Traffic") cti(Reduced Form)
 
areg bw $lead $x $time $birthnobw if birth_year>=1997,a(bl) $cl
outreg2 using $t,append drop($time) sortvar($lead leadmale $iv lntraffic $x $birthnobw) $o cti(OLS)

xtivreg bw ($lead=$iv) lntraffic $x $time $birthnobw if birth_year>=1997, fe
outreg2 using $t,append drop($time) sortvar($lead leadmale $iv lntraffic $x $birthnobw) $o cti(iv)

areg bw $leadm $x $time $birthnobw if birth_year>=1997,a(bl) $cl
outreg2 using $t,append drop($time) sortvar($lead leadmale $iv lntraffic $x $birthnobw) $o cti(OLS)

xtivreg bw ($lead leadmale=$iv yhatmale) lntraffic $x $time $birthnobw if birth_year>=1997, fe
outreg2 using $t,append drop($time) sortvar($lead leadmale $iv lntraffic $x $birthnobw) $o cti(iv)
 

/* IV regressions - any suspend*/

global t "$results\iv_inter_anysuspend.xls"
global leadm "gmean leadmale"

iis bl
xi: xtreg anysuspend $leadm $x $time, fe $cl
outreg2 using $t,replace $o keep($leadm)  cti(FE) ti(Table 7: IV Estimates of Lead, Any Suspension and Any Detention/Incarceration, Instrument Based on Road Proximity)

iis momid
xi: xtreg anysuspend $leadm $x $time if sibsample==1 , fe $cl
outreg2 using $t,append $o keep($leadm)  cti(FE)

iis bl
xi: xtivreg anysuspend ($leadm=$iv yhatmale) lntraffic $x $time,fe first
outreg2 using $t,append $o keep($leadm)  cti(FE-IV) 

estimates store H4

hausman H4 H3, force constant


xi: xtreg anysuspend $leadm e emale lntraffic $x $time,fe 


/* Table 7 robustness results: certificates, drop roads, control for infractions in school*/

/* add average outcomes of classmates*/

cap drop _merge
sort new_school_id3 birth_year
merge new_school_id3 birth_year using school3means.dta
tab _merge
drop if _merge==2
replace esinfract=(esinfract-numinfract3)/(s3n-1)

replace esinfract=0 if _merge==1
gen esmiss=_merge==1
drop _merge
sort new_school_id6 birth_year

merge new_school_id6 birth_year using school6means.dta
tab _merge
drop if _merge==2
replace msinfract=(msinfract-numinfract6)/(s6n-1)

replace msinfract=0 if _merge==1
gen msmiss=_merge==1
drop _merge
sort new_school_id9 birth_year
merge new_school_id9 birth_year using school9means.dta
tab _merge
drop if _merge==2
replace hsinfract=(hsinfract-numinfract9)/(s9n-1)


replace hsinfract=0 if _merge==1
gen hsmiss=_merge==1
drop _merge


summ esinfract msinfract hsinfract

gen avginfract=msinfract
replace avginfract=esinfract if avginfract==. 
replace avginfract=hsinfract if avginfract==. 
label var avginfract "Average infractions per child in school and grade"


/* add roads data*/
cap drop _merge
sort tr
merge tr using ruby.dta
tab _merge
tab dev_index
gen newroads=dev_index==4 | dev_index==5

/* add certificate data*/
cap drop _merge
cap drop lead_year
gen lead_year=birth_year
gen lead_qtr=quarter(approxdob)
tab lead_year
tab lead_qtr

sort tract2010 lead_year lead_qtr
merge tract2010 lead_year lead_qtr using certstomerge.dta

gen certs=certsum0/(housing_units*(1-share_post79))
replace certs=0 if certsum0==.

label var certs "Certificates in tract per old housing unit"

global road "if newroads==0"
global control "avginfract" 
global cert "certs"

global y "anysuspend"
global t "$results\robust.xls"

xi: areg $y $leadm $x $time, a(bl) $cl
outreg2 $leadm using $t,replace keep($leadm) $o ti(Table 7: OLS & IV Estimates  Lead and Suspension, Robustness Checks) addtext(Additional Controls, None, Sample, Full)

xi: areg $y $leadm $control $x $time, a(bl)  $cl
outreg2 $leadm $control using $t,append keep($leadm $control) $o addtext(Additional Controls, Infractions/Child in School*grade, Sample, Full)

xi: areg $y $leadm $cert $x $time, a(bl)  $cl
outreg2 $leadm $cert using $t,append keep($leadm $cert) $o addtext(Additional Controls, Certificates in Tract at Birth, Sample, Full)

xi: areg $y $leadm $x $time $road, a(bl)  $cl
outreg2 $leadm using $t, append keep($leadm) $o addtext(Additional Controls, None, Sample, Drop tracts w/new roads)

global t "$results\robustiv.xls"


xi: xtivreg $y ($leadm=$iv yhatmale) $x lntraffic $time, fe 
outreg2 $leadm using $t,replace keep($leadm) $o ti(Panel B: IV Estimates) addtext(Additional Controls, None, Sample, Full)

xi: xtivreg $y ($leadm=$iv yhatmale) $control $x lntraffic $time, fe 
outreg2 $leadm $control using $t,append keep($leadm $control) $o addtext(Additional Controls, Infractions/Child in School*grade, Sample, Full)

xi: xtivreg $y ($leadm=$iv yhatmale) $cert $x lntraffic $time, fe 
outreg2 $leadm $cert using $t,append keep($leadm $cert) $o addtext(Additional Controls, Certificates in Tract at Birth, Sample, Full)

xi: xtivreg $y ($leadm=$iv yhatmale) $x lntraffic $time $road, fe 
outreg2 $leadm using $t, append keep($leadm) $o addtext(Additional Controls, None, Sample, Drop tracts w/new roads)


/* gradient - Appendix Table 1*/

gen gmeantime=gmean*(birth_year-1992) 
replace blacktime=black*(birth_year-1992)
gen somefreetime=somefree*(birth_year-1992)
gen alwaysfreetime=alwaysfree*(birth_year-1992)
label var blacktime "Black*year of birth"
label var somefreetime "Sometimes free lunch*year of birth"
label var alwaysfreetime "Always free lunch*year of birth"
label var gmeantime "Lead*year of birth"

areg gmean $x blacktime somefreetime alwaysfreetime birth_year if (birth_year>=1993 & birth_year<=1998) & numinfract9~=., a(bl)
outreg2 using $results\gradient.xls,replace $o keep(black somefree alwaysfree blacktime somefreetime alwaysfreetime) 

areg numinfract9 gmean gmeantime $x birth_year if (birth_year>=1993 & birth_year<=1998), a(bl)
outreg2 using $results\gradient.xls,append $o keep(gmean gmeantime black somefree alwaysfree)  

areg numinfract9 gmean gmeantime $x blacktime somefreetime alwaysfreetime birth_year if (birth_year>=1993 & birth_year<=1998), a(bl)
outreg2 using $results\gradient.xls,append $o keep(gmean gmeantime black blacktime somefree somefreetime alwaysfree alwaysfreetime)  



/* crime*/

cap drop _merge
sort pid
merge pid using allcrime.dta
tab _merge
*drop if _merge==2
replace ridoc=. if _merge==2
replace ridoc=0 if _merge==1
replace rits=0 if _merge==1
replace anyarrest=0 if _merge==1
replace anycrime=0 if _merge==1


replace numarrest=0 if numarrest==. 
gen ridoc2=ridoc
replace ridoc2=1 if rits==1

replace rits=. if birth_year>1997


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

global xcrime "black white hisp somefree alwaysfree male_ride"


/* add crime results to table 3*/


global if3 "if birth_year>=1991 & birth_year<=1999"

replace ridoc2=. if birth_year<1991 | birth_year>1999

global lead "gmean"

foreach y in ridoc2 {
global t "$results\table3ols.xls"

iis muni_code
xi: areg `y' $lead male_ride $time12 $if3, a(muni_code)  $cl
outreg2 using $t,append $o keep($lead male_ride) addtext(FE, Municipality, Birth cohorts, 1991-1999) cti(Any Detention/Incarceration)

iis muni_code
xi: areg `y' $lead $xcrime $time12 $if3, a(muni_code)  $cl
outreg2 using $t,append $o keep($lead $xcrime) addtext(FE, Municipality, Birth cohorts, 1991-1999) 

iis bl
areg `y' $lead $xcrime $time12 $if3,a(bl)  $cl
outreg2 using $t,append $o keep($lead $xcrime) addtext(FE, Block Group, Birth cohorts, 1991-1999) 

xi: areg `y' $lead $xcrime $time12 i.schoolid $if3, a(bl)  $cl
outreg2 using $t,append $o keep($lead $xcrime) addtext(FE, block & school, Birth cohorts, 1991-1999) 

xi: areg `y' $lead leadmale $xcrime $time12 i.schoolid $if3, a(bl)  $cl
outreg2 using $t,append $o keep($lead leadmale $xctime) addtext(FE, Block Group, Birth cohorts, 1991-1999) 

}

global lead "gmean leadmale"
global y "ridoc2"
global t "$results\ivridoc2.xls"


/* IV regressions*/

xi: xtreg $y $lead $xcrime $time12 $if3,fe
outreg2 using $t,replace $o keep($lead)  cti(Neighborhood FE)  

areg gmean $iv lntraffic $xcrime $time12 $if3, a(bl) $cl
drop yhat yhatmale

predict yhatcrime
replace yhatcrime=. if ridoc2==.
gen yhatmale=yhatcrime*male_ride
xi: xtivreg $y ($lead=$iv yhatmale) lntraffic $xcrime $time12 $if3,fe
outreg2 using $t,append $o keep($lead)  cti(IV) 

