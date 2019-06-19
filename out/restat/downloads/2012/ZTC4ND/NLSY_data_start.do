clear
set mem 300m
set more off
cd C:\data\timeuse
use C:\data\restricted\nlsy_big3, clear
gen study5down=( total_hrs_study<=5) if  total_hrs_study!=.
gen class5down=( total_hrs_class<=5) if  total_hrs_class!=.
gen class20up=( total_hrs_class>=20.5) if  total_hrs_class!=.
gen class16up=( total_hrs_class>=16.5) if  total_hrs_class!=.
replace study20up=. if total_hrs_study==.
replace study16up=. if total_hrs_study==.

/* keep full-time */
keep if ftptcol==1

sort ipeds
merge ipeds using C:\data\timeuse\ipeds_nlsy
gen carnegie_=carnegie
gen fath_nohs=(dadcol ==0&dadhsgrad ==0) if dadedmis==0
gen fath_hs=(dadhsgrad ==1) if dadedmis==0
gen fath_col=(dadcol ==1) if dadedmis==0
gen fathed=1 if dadedmis==0

replace majorgroup=. if major<100
tabulate majorgroup, gen(majordum)

drop black
*drop white
drop hispanic
ren white2 white 
ren black2 black
ren hispanic2 hisp
ren asian2 asian
ren age81 age
gen rel_age=age-18 if grade81==13
replace rel_age=age-19 if grade81==14
replace rel_age=age-20 if grade81==15
replace rel_age=age-21 if grade81==16

gen work=0 if hrswork81==-4|hrswork81==0
replace work=1 if hrswork81>0 &hrswork81<=20
replace work=2 if hrswork81>20 &!missing(hrswork81)


gen work1=(work==0) if !missing(work)
gen work2=(work==1) if !missing(work)
gen work3=(work==2) if !missing(work)
gen hrstudy=total_hrs_study
gen hrsclass=total_hrs_class
gen class=total_hrs_class
gen hrswork=hrswork81
replace hrswork=0 if hrswork==-4|hrswork==0
gen working =hrswork
keep if hrstudy!=.
gen carDR=(carnegie==15|carnegie==16) if !missing(carnegie)
gen carMas=(carnegie==21|carnegie==22) if !missing(carnegie)
gen carBacLib=(carnegie==31) if !missing(carnegie)
gen carBacOth=(carnegie==32) if !missing(carnegie)

/*Table 1 Column 3,4  Table 2 Column 2 */
sum hrstudy study20up study16up study5down hrsclass class20up class16up class5down hrswork work1 work2 work3 white asian black female fath_nohs fath_hs fath_col [aw=weight81]
sum carDR carMas carBacLib carBacOth [aw=weight81]

save nlsymerge, replace

/*Table 6 Column 2 (Subtract framing effect of 2.89 to get table results) */

replace hrstudy=hrstudy-2.89
reg hrstudy [pw=weight81] 

outreg using pol1.xls , replace 
reg hrstudy [pw=weight81] if work==0
outreg using pol1.xls , append 
reg hrstudy [pw=weight81] if work==1
outreg using pol1.xls , append 
reg hrstudy [pw=weight81] if work==2
outreg using pol1.xls, append 

reg hrstudy [pw=weight81] if fath_nohs==1
outreg using pol1.xls , append 
reg hrstudy  [pw=weight81] if fath_hs==1
outreg using pol1.xls , append 
reg hrstudy  [pw=weight81] if fath_col==1
outreg using pol1.xls , append 

reg hrstudy [pw=weight81] if female==0
outreg using pol1.xls , append 
reg hrstudy  [pw=weight81] if female==1
outreg using pol1.xls , append 


reg hrstudy [pw=weight81] if white==1
outreg using pol1.xls , append 
reg hrstudy  [pw=weight81] if asian==1
outreg using pol1.xls , append 
reg hrstudy  [pw=weight81] if black==1
outreg using pol1.xls , append 


reg hrstudy [pw=weight81] if majorgroup==1
outreg using pol2.xls , replace 
reg hrstudy [pw=weight81] if majorgroup==2
outreg using pol2.xls , append 
reg hrstudy [pw=weight81] if majorgroup==3
outreg using pol2.xls, append 
reg hrstudy [pw=weight81] if majorgroup==4
outreg using pol2.xls , append 
reg hrstudy [pw=weight81] if majorgroup==5
outreg using pol2.xls, append 
reg hrstudy [pw=weight81] if majorgroup==6
outreg using pol2.xls , append 
reg hrstudy [pw=weight81] if majorgroup==7
outreg using pol2.xls, append 
reg hrstudy [pw=weight81] if majorgroup==8
outreg using pol2.xls , append 
reg hrstudy [pw=weight81] if majorgroup==9
outreg using pol2.xls, append 

reg hrstudy [pw=weight81] if carnegie==15|carnegie==16
outreg using pol3.xls , replace 
reg hrstudy [pw=weight81] if carnegie==21|carnegie==22
outreg using pol3.xls , append 
reg hrstudy [pw=weight81] if carnegie==31
outreg using pol3.xls, append 
reg hrstudy [pw=weight81] if carnegie==32
outreg using pol3.xls, append 

