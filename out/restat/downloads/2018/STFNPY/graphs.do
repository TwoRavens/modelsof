clear
cap log close
set more off

graphs.log,replace


global results ""

global lead "gmean"
global time "birth_year"
global sample "keep if birth_year>=1990 & birth_year<=2004"
global tl "1990"
global th "2004"


use $lead $time avg50 yob* black white hisp asian neverfree somefree alwaysfree numinfract* suspendout somefree male_ride anyinfract numyears_inf bl pid momedu bw using temp_add.dta


sort pid
merge pid using less_add_newroads.dta
tab _merge

keep if _merge==3

$sample

cap drop _merge
gen tract2010=substr(firsttract, 1,11)
sort tract2010

merge tract2010 using tractmuni_xwalk.dta
egen muni_code=group(muni_name)
/* rural*/

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

global vmt "1609"
global vmt "1"

gen vmt_pri=3327/$vmt if rural==0
gen vmt_sec=572/$vmt if rural==0
gen vmt_ter=146/$vmt if rural==0
replace vmt_pri=1031/$vmt if rural==1
replace vmt_sec=132/$vmt if rural==1
replace vmt_ter=19/$vmt if rural==1

destring firstfips,replace


local x=25
while `x'<=50 {

gen avg`x'_123=avg_pri`x'*vmt_pri+avg_sec`x'*vmt_sec + avg_ter`x'*vmt_ter
label var avg`x'_123 "Traffic within `x'm"

local x=`x'+25
}


set more off
gen traffic2=avg25_123+(avg50_123-avg25_123)*.25
label var traffic2 "Measure of Traffic"

global traffic25 "avg25_123"

global traffic "traffic2"





iis bl
xtreg $lead black white hisp neverfree somefree male_ride if birth_year==1990 | birth_year==1991, fe
predict yhat

egen x=rownonmiss($traffic anyinfract numyears_inf $lead black hisp white neverfree male_ride birth_year bl)
tab x
keep if x==11



label var $lead "Average Lead Level"

label var birth_year "Year of Birth"

gen lead90=$lead if birth_year==$tl & $lead<=15
gen lead04=$lead if birth_year==$th & $lead<=15
label var lead90 "$tl birth cohort"
label var lead04 "$th birth cohort"

*kdensity $y if $char==1 & lead_year==$startyear, addplot(kdensity $y if $char==1 & lead_year==$endyear) legend(label(1 "$startyear") label(2 "$endyear")) ti("White") scheme(s2mono)

kdensity lead90, addplot (kdensity lead04) ti(Appendix Figure 1: Child Lead Levels by Birth Cohort) xtitle("Child Average Blood Lead Level") legend(label(1 "$tl Birth Cohort") label(2 "$th Birth Cohort")) scheme(s2mono) note("The distribution of the geometric mean of each child's BLL over" "the first 72 months of life is presented for children born in 1990 and 2004" "corresponding to the oldest and youngest children in our sample.")
graph export $results\appfigure1.pdf,replace


/* trends in lead by child char*/

preserve
keep if $time>1990 & $time<=2005
keep if black==1 | white==1

collapse (mean) $lead, by($time black)

label var $lead "Average Lead Level"
label var $time "Year of Birth"

scatter $lead $time if black==1, ti("African American Children")
graph save $results\black_lead.gph,replace 


scatter $lead $time if black==0, ti("White Children")
graph save $results\white_lead.gph,replace 

label define racel 0 "White" 1 "African American"
label values black racel

gen leadbl=$lead if black==1
gen leadwt=$lead if black==0
label var leadbl "African American"
label var leadwt "White"

scatter leadbl $time if black==1 || scatter leadwt $time if black==0, ti("By Race") scheme(s2mono)
graph save $results\lead_byrace.gph,replace



restore
preserve

keep if $time>=$tl & $time<=$th
collapse (mean) $lead, by($time neverfree)


label var $lead "Average Lead Level"
label var $time "Year of Birth"

scatter $lead $time if neverfree==1, ti("Paid Lunch Children")
graph save $results\nofree_lead.gph,replace 

scatter $lead $time if neverfree==0, ti("Free Lunch Children")
graph save $results\free_lead.gph,replace 

gen leadfr=$lead if neverfree==0
gen leadnotfr=$lead if neverfree==1
label var leadfr "Free Lunch"
label var leadnotfr "Paid Lunch"


scatter leadfr $time if neverfree==0 || scatter leadnotfr $time if neverfree==1, ti("By Free Lunch Status") scheme(s2mono) 
graph save $results\lead_byinc.gph,replace


graph combine $results\lead_byrace.gph $results\lead_byinc.gph, ycommon ti("Appendix Figure 2: Trends in Lead Levels" "by Race & Free Lunch Status") scheme(s2mono) note("The geometric mean over all BLLs is computed for each child."  "The average over all geometric means is then calculated" "by child birth cohort and either race or free lunch status.")
graph export $results\appfigure2.pdf,replace 

/* trends in lead by road traffic*/


*use tr $lead $time numyears_inf avg50 numinfract* pid black hisp white neverfree somefree male_ride anyinfract momedu bw bl using temp_add.dta

restore

global time "birth_year"
label var $time "Year of Birth"
keep if $time>=$tl & $time<=$th
replace numyears_inf=. if numyears_inf<2


replace numinfract=numinfract/numyears_inf


egen median50=median($traffic)
egen pct75=pctile($traffic), p(75)
egen pct25=pctile($traffic), p(25)

gen high50=$traffic>=median50
gen high25=1 if $traffic>=pct75 & $traffic~=. 
replace high25=0 if $traffic<=pct25
gen low25=1 if $traffic<=pct25
replace low25=0 if $traffic>pct25 & $traffic~=. 

tab high25
tab low25


global high "high25"

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


global lead "gmean"
gen lths=momedu<12 if momedu~=. 

gen lbw=bw<2500 if bw~=. 
replace rits=. if birth_year>1997
drop if numyears_inf<2

summ $traffic, det

gen anysuspend=suspendout~=0 if suspendout~=.
label var anysuspend "Any out of school suspension"
summ anyinfract anysuspend
gen anyinfract9=numinfract9>0 & numinfract9~=. 
gen anyinfract78=numinfract7>0 & numinfract7~=. 

replace ridoc2=. if birth_year<1991 | birth_year>1999

gen highses=yhat<=5.38
tab highses

gen leadhighses=$lead if highses==1

preserve

collapse(mean) $lead leadhighses yhat black hisp white neverfree numinfract9 numinfract7 anyinfract7 anyinfract9 anysuspend rits ridoc2 momedu bw lths lbw, by (birth_year $high)

replace rits=rits*10000
label var rits "Juvenile Detention/10000"

replace ridoc2=ridoc2*10000
label var ridoc2 "Detention or Incarceration/1000"
gen leadhigh=$lead if $high==1
gen leadlow=$lead if $high==0
label var leadhigh "High"
label var leadlow "Low"

label var birth_year "Year of Birth"

scatter leadhigh $time if $high==1 || scatter leadlow $time if $high==0, ti("Average Lead") scheme(s2mono)
graph export $results\lead_bytraffic.pdf,replace
graph save $results\lead_bytraffic.gph,replace


replace leadhigh=black if $high==1
replace leadlow=black if $high==0
label var leadhigh "High"
label var leadlow "Low"

scatter leadhigh $time if $high==1 || scatter leadlow $time if $high==0, ti("Share Black") scheme(s2mono) yscale(range(0,1))
graph save $results\black_bytraffic.gph,replace

replace leadhigh=(white) if $high==1
replace leadlow=(white) if $high==0
label var leadhigh "High"
label var leadlow "Low"


scatter leadhigh $time if $high==1 || scatter leadlow $time if $high==0, ti("Share White") scheme(s2mono) yscale(range(0,1))
graph save $results\white_bytraffic.gph,replace

replace leadhigh=(1-neverfree) if $high==1
replace leadlow=(1-neverfree) if $high==0

scatter leadhigh $time if $high==1 || scatter leadlow $time if $high==0, ti("Share Free Lunch") scheme(s2mono) yscale(range(0,1))
graph save $results\free_bytraffic.gph,replace


replace leadhigh=(momedu) if $high==1
replace leadlow=(momedu) if $high==0

scatter leadhigh $time if $high==1 & birth_year>=1997 || scatter leadlow $time if $high==0 & birth_year>=1997 , ti("Maternal Years of Schooling") scheme(s2mono) yscale(range(10,14))
graph save $results\edu_bytraffic.gph,replace


graph combine $results\lead_bytraffic.gph $results\free_bytraffic.gph $results\white_bytraffic.gph  $results\edu_bytraffic.gph, ti("Figure 3: Trends in Child Characteristics by Traffic Density") scheme(s2mono) note("High(low) traffic defined as top(bottom) quartile of traffic volume in the state." "Maternal Education only avilable for chidlren born post 1996.")
graph export $results\figure3.pdf,replace


replace leadhigh=(leadhighses) if $high==1
replace leadlow=(leadhighses) if $high==0

scatter leadhigh $time if $high==1 || scatter leadlow $time if $high==0, ti("Figure 4: Trends in Lead Levels for High SES Children" "By Traffic Density") scheme(s2mono) yscale(range(2,6)) note("Child SES is measured using the preidcted lead level of the child based on estimates" "for children born 1990-1991 and applied to all children in the sample." "Our proxy for high SES children is a predicted lead level in the bottom quartile.")
graph save $results\figure4.gph,replace
graph export $results\figure4.pdf,replace



restore
preserve

gen lead2=$lead
replace lead2=1
summ $traffic, det


xtile avg50r=($traffic), nq(100)
label var avg50r "Percentile of Traffic"


areg $lead, a(bl)
predict leadhat
gen resid=$lead-leadhat

areg $traffic, a(bl)
predict traffichat
gen residt=$traffic-traffichat

xtile residpct=(residt), nq(100)
label var residpct "Percentile of Traffic(Residual)"

gen n=1

collapse (mean) $lead resid (sum) n, by (birth_year residpct)
label var $lead "Lead"
*label var anysuspend "Any suspension"
label var resid "Lead (Residual)"
label var residpct "Percentile of Traffic (Residual)"

gen x=resid if birth_year==$tl
gen y=resid if birth_year==$th

label var x "$tl birth cohort"
label var y "$th birth cohort"

twoway (scatter x residpct if birth_year==$tl) (scatter y residpct if birth_year==$th), ytitle (Lead(Residual)) ti("Figure 2:" "Child Lead Levels and Traffic" "by Birth Cohort") scheme(s2mono) note("Residuals from separate regressions of lead and traffic on census block group FE" "for children born in 1990 and 2004.")
graph save leadresid.gph,replace

graph export $results\figure2.pdf,replace

