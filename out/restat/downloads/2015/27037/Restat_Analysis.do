
clear all
clear matrix
macro drop _all
set type double
set more off
capture log close
set mem 2g


local origdatadir "Directory of original IHC data files" 
local newdatadir  "Directory to which to write new data files"


log using "`newdatadir'final.log", replace

*****************************************************************************
************* Pooling different waves of ABS survey data  *******************
***** com_idsX = IHCS wave X , Combined of hh, income unit, person files ****
*****************************************************************************

*****************************************************************************
****  Data Dictionary and Label described below *****************************
*****************************************************************************


use  "`origdatadir'com_ids94.dta", replace
gen identifier=199495
append using  "`origdatadir'com_ids95.dta" 
gen identifier2=199596
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_ids96.dta" 
gen identifier2=199697
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_ids97.dta" 
gen identifier2=199798
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_ids99.dta" 
gen identifier2=199900
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_ids00.dta" 
gen identifier2=200001
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_ids02.dta" 
gen identifier2=200203
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_sih03.dta" 
gen identifier2=200304
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_sih05.dta" 
gen identifier2=200506
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_sih08.dta" 
gen identifier2=200708
replace identifier=identifier2 if identifier==.
drop identifier2
append using  "`origdatadir'com_sih10.dta" 
gen identifier2=200910
replace identifier=identifier2 if identifier==.
drop identifier2



****** Sample Extraction *******
 keep if abspid<3
 keep if (agecp>=22 & agecp<=27) |(agebc>=22 & agebc<=27)
 keep if (identifier==199495 & yoa<=2)|(identifier==199596 & yoa<=2)|(identifier==199697 & yoa<=3)| (identifier==199798 & yoa<=3)| (identifier==199900 & yoa<=3)|(identifier==200001 & yoa<=3)| (identifier==200203 & yoabc<=1)| (identifier==200304 & yoabc<=1)|(identifier==200506 & yoabc<=1)|(identifier==200708 & yoabc<=2)| (identifier==200910 & yoabc<=2)

*******************  Generating Variables ******************
 gen age=.
 replace age=60 if agecp==22
 replace age=61 if agecp==23
 replace age=62 if agecp==24
 replace age=63 if agecp==25
 replace age=64 if agecp==26
 replace age=6569 if agecp==27
 replace age=60 if agebc==22
 replace age=61 if agebc==23
 replace age=62 if agebc==24
 replace age=63 if agebc==25
 replace age=64 if agebc==26
 replace age=6569 if agebc==27
 gen sage=(age<6569)
 tab age if sage==1,gen (hage) 
 gen fem=(sexp==2)
  gen male=(1-fem)
 gen single=.
 replace single=1 if (mstatcp>1)& mstatp==.
 replace single=1 if (mstatp>1) & mstatcp==.
 replace single=0 if single==.
 gen state_p=.
 replace state_p=statecu if statehbc==.
 replace state_p=statehbc if statecu==.
 gen iu_per=.
 replace iu_per=personsu if  personsu!=.
 replace iu_per=prsnsubc if  prsnsubc!=.
 replace iu_per=pershbc  if  pershbc!=.
 gen hval=hvaluech
 gen edu1=.
 gen edu2=.
 gen edu3=.
 replace edu1=1 if (hqualcp==1 |hqualcp==9) & (identifier<=199798)
 replace edu2=1 if( hqualcp==2 |hqualcp==3 | hqualcp==4 | hqualcp==5 | hqualcp==6) & (identifier<=199798)
 replace edu3=1 if (hqualcp==7 | hqualcp==8)& (identifier<=199798)
 replace edu1=1 if (hqualcp==1 |hqualcp==4)  & (identifier==199900 | identifier==200001)
 replace edu2=1 if (hqualcp==2) & (identifier==199900 | identifier==200001)
 replace edu3=1 if (hqualcp==3) & (identifier==199900 | identifier==200001)
 replace edu1=1 if (hqualbc==1 |hqualbc==4)   & (identifier==200203)
 replace edu2=1 if (hqualbc==2) & (identifier==200203)
 replace edu3=1 if (hqualbc==3) & (identifier==200203)
 replace edu1=1 if (hqualbc==7 |hqualbc==8) & (identifier>200203)
 replace edu2=1 if (hqualbc==1 |hqualbc==2 |hqualbc==3)  & (identifier>200203)
 replace edu3=1 if (hqualbc==4 |hqualbc==5 |hqualbc==6)  & (identifier>200203)
 replace edu1=0 if edu1==.
 replace edu2=0 if edu2==.
 replace edu3=0 if edu3==.
 gen retired=.
 replace retired=1 if lfstbcp==4
 replace retired=1 if lfscp==3
 replace retired=0 if retired==.
 gen part=(1-retired)
 gen agepension=(iagecp>0)
 gen dispension=(idsuppcp>0 |idisbcp>0)
 gen anygovmon=.
 replace anygovmon=(iagecp>0  |  iwifeccp>0| inewlscp>0 |idsuppcp>0 |imatucp>0  ) if  identifier<=199798
 replace anygovmon=(iagecp>0  | icareacp>0 | inewlscp>0| idsuppcp>0 |icarepcp>0| imatucp>0) if (identifier==199900 |identifier==200001|identifier==200203|identifier==200304|identifier==200506|identifier==200708)
 replace anygovmon=(iagecp>0  |icareacp>0 | inewlscp>0| idsuppcp>0 |icarepcp) if identifier==200910
 replace anygovmon=0 if anygovmon==.
 gen anygovmon_napa=.
 replace anygovmon_napa=(iwifeccp>0| inewlscp>0 |idsuppcp>0 |imatucp>0  ) if  identifier<=199798
 replace anygovmon_napa=(icareacp>0 | inewlscp>0| idsuppcp>0 |icarepcp>0| imatucp>0) if (identifier==199900 |identifier==200001|identifier==200203|identifier==200304|identifier==200506|identifier==200708)
 replace anygovmon_napa=(icareacp>0 | inewlscp>0| idsuppcp>0 |icarepcp) if identifier==200910
 replace anygovmon_napa=0 if anygovmon==.
 gen owner=. 
 gen owner_nomor=.
 replace owner=(natoccu==1|natoccu==2) if natoccu!=.
 replace owner=(tenureh==1|tenureh==2) if tenureh!=.
 replace owner=(tenurecf==1|tenurecf==2) if tenurecf!=.
 replace owner_nomor=(natoccu==1) if natoccu!=.
 replace owner_nomor=(tenureh==1) if tenureh!=.
 replace owner_nomor=(tenurecf==1) if tenurecf!=.
 gen year=.
 replace year=1994 if (qtritrwu==1 |qtritrwu==2) & identifier==199495
 replace year=1995 if (qtritrwu==3 |qtritrwu==4) & identifier==199495
 replace year=1995 if (qtritrwu==1 |qtritrwu==2) & identifier==199596
 replace year=1996 if (qtritrwu==3 |qtritrwu==4) & identifier==199596
 replace year=1996 if (qtritrwu==1 |qtritrwu==2) & identifier==199697
 replace year=1997 if (qtritrwu==3 |qtritrwu==4) & identifier==199697
 replace year=1997 if (qtritrwu==1 |qtritrwu==2) & identifier==199798
 replace year=1998 if (qtritrwu==3 |qtritrwu==4) & identifier==199798
 replace year=1999 if (qtritrwu==1 |qtritrwu==2) & identifier==199900
 replace year=2000 if (qtritrwu==3 |qtritrwu==4) & identifier==199900
 replace year=2000 if (qtritrwu==1 |qtritrwu==2) & identifier==200001
 replace year=2001 if (qtritrwu==3 |qtritrwu==4) & identifier==200001
 replace year=2002 if (quarterh==1 |quarterh==2) & identifier==200203
 replace year=2003 if (quarterh==3 |quarterh==4) & identifier==200203
 replace year=2003 if (quarterh==1 |quarterh==2) & identifier==200304
 replace year=2004 if (quarterh==3 |quarterh==4) & identifier==200304
 replace year=2005 if (quarterh==1 |quarterh==2) & identifier==200506
 replace year=2006 if (quarterh==3 |quarterh==4) & identifier==200506
 replace year=2007 if (quarterh==1 |quarterh==2) & identifier==200708
 replace year=2008 if (quarterh==3 |quarterh==4) & identifier==200708 
 replace year=2009 if (quarterh==1 |quarterh==2) & identifier==200910
 replace year=2010 if (quarterh==3 |quarterh==4) & identifier==200910
 gen quarter=.
 replace quarter=1 if qtritrwu==3
 replace quarter=2 if qtritrwu==4
 replace quarter=3 if qtritrwu==1
 replace quarter=4 if qtritrwu==2
 replace quarter=1 if quarterh==3
 replace quarter=2 if quarterh==4
 replace quarter=3 if quarterh==1
 replace quarter=4 if quarterh==2
 gen  byear=year-age
 gen  agev2=age
 replace agev2=67 if age>65
 gen  byearv2=year-agev2
 gen  bquart=yq(byear, quarter)
 format bquart  %tq 
 gen dt1=0
 replace dt1=1/5   if bquart==tq(1935q3)
 replace dt1=2/5   if bquart==tq(1935q4)
 replace dt1=3/5   if bquart==tq(1936q1)
 replace dt1=4/5   if bquart==tq(1936q2)
 replace dt1=1     if bquart==tq(1936q3)
 replace dt1=1     if bquart==tq(1936q4)
 replace dt1=1     if bquart==tq(1937q1)
 replace dt1=1     if bquart==tq(1937q2)
 replace dt1=1     if bquart==tq(1937q3)
 replace dt1=1     if bquart==tq(1937q4)
 replace dt1=1     if bquart==tq(1938q1)
 replace dt1=1     if bquart==tq(1938q2)
 replace dt1=4/5   if bquart==tq(1938q3)
 replace dt1=3/5   if bquart==tq(1938q4)
 replace dt1=2/5   if bquart==tq(1939q1)
 replace dt1=1/5   if bquart==tq(1939q2)
 gen dt2=0
 replace dt2=1/5   if bquart==tq(1938q3)
 replace dt2=2/5   if bquart==tq(1938q4)
 replace dt2=3/5   if bquart==tq(1939q1)
 replace dt2=4/5   if bquart==tq(1939q2)
 replace dt2=1     if bquart==tq(1939q3)
 replace dt2=1     if bquart==tq(1939q4)
 replace dt2=1     if bquart==tq(1940q1)
 replace dt2=1     if bquart==tq(1940q2)
 replace dt2=1     if bquart==tq(1940q3)
 replace dt2=1     if bquart==tq(1940q4)
 replace dt2=1     if bquart==tq(1941q1)
 replace dt2=1     if bquart==tq(1941q2)
 replace dt2=4/5   if bquart==tq(1941q3)
 replace dt2=3/5   if bquart==tq(1941q4)
 replace dt2=2/5   if bquart==tq(1942q1)
 replace dt2=1/5   if bquart==tq(1942q2)
 gen dt3=0
 replace dt3=1/5   if bquart==tq(1941q3)
 replace dt3=2/5   if bquart==tq(1941q4)
 replace dt3=3/5   if bquart==tq(1942q1)
 replace dt3=4/5   if bquart==tq(1942q2)
 replace dt3=1     if bquart==tq(1942q3)
 replace dt3=1     if bquart==tq(1942q4)
 replace dt3=1     if bquart==tq(1943q1)
 replace dt3=1     if bquart==tq(1943q2)
 replace dt3=1     if bquart==tq(1943q3)
 replace dt3=1     if bquart==tq(1943q4)
 replace dt3=1     if bquart==tq(1944q1)
 replace dt3=1     if bquart==tq(1944q2)
 replace dt3=4/5   if bquart==tq(1944q3)
 replace dt3=3/5   if bquart==tq(1944q4)
 replace dt3=2/5   if bquart==tq(1945q1)
 replace dt3=1/5   if bquart==tq(1945q2)
 gen dt4=0
 replace dt4=1/5   if bquart==tq(1944q3)
 replace dt4=2/5   if bquart==tq(1944q4)
 replace dt4=3/5   if bquart==tq(1945q1)
 replace dt4=4/5   if bquart==tq(1945q2)
 replace dt4=1     if bquart==tq(1945q3)
 replace dt4=1     if bquart==tq(1945q4)
 replace dt4=1     if bquart==tq(1946q1)
 replace dt4=1     if bquart==tq(1946q2)
 replace dt4=1     if bquart==tq(1946q3)
 replace dt4=1     if bquart==tq(1946q4)
 replace dt4=1     if bquart==tq(1947q1)
 replace dt4=1     if bquart==tq(1947q2)
 replace dt4=4/5   if bquart==tq(1947q3)
 replace dt4=3/5   if bquart==tq(1947q4)
 replace dt4=2/5   if bquart==tq(1948q1)
 replace dt4=1/5   if bquart==tq(1948q2)
 gen dt5=0
 replace dt5=1/5   if bquart==tq(1947q3)
 replace dt5=2/5   if bquart==tq(1947q4)
 replace dt5=3/5   if bquart==tq(1948q1)
 replace dt5=4/5   if bquart==tq(1948q2)
 replace dt5=1     if bquart==tq(1948q3)
 replace dt5=1     if bquart==tq(1948q4)
 replace dt5=1     if bquart==tq(1949q1)
 replace dt5=1     if bquart==tq(1948q4)
 replace dt5=1     if bquart==tq(1949q1)
 replace dt5=1     if bquart==tq(1949q2)
 replace dt5=1     if bquart==tq(1949q3)
 replace dt5=1     if bquart==tq(1949q4)
 replace dt5=1     if bquart==tq(1950q1)
 replace dt5=1     if bquart==tq(1950q2)
 gen t1=0
 replace t1=1/5   if bquart==tq(1935q3)
 replace t1=2/5   if bquart==tq(1935q4)
 replace t1=3/5   if bquart==tq(1936q1)
 replace t1=4/5   if bquart==tq(1936q2)
 replace t1=1     if bquart==tq(1936q3)
 replace t1=1     if bquart==tq(1936q4)
 gen t2=0
 replace t1=4/5    if bquart==tq(1937q1)
 replace t2=1/5    if bquart==tq(1937q1)
 replace t1=3/5    if bquart==tq(1937q2)
 replace t2=2/5    if bquart==tq(1937q2)
 replace t1=2/5    if bquart==tq(1937q3)
 replace t2=3/5    if bquart==tq(1937q3)
 replace t1=1/5    if bquart==tq(1937q4)
 replace t2=4/5    if bquart==tq(1937q4)
 replace t2=1      if bquart==tq(1938q1)
 replace t2=1      if bquart==tq(1938q2)
 gen t3=0
 replace t2=4/5     if bquart==tq(1938q3)
 replace t3=1/5     if bquart==tq(1938q3)
 replace t2=3/5     if bquart==tq(1938q4)
 replace t3=2/5     if bquart==tq(1938q4)
 replace t2=2/5     if bquart==tq(1939q1)
 replace t3=3/5     if bquart==tq(1939q1)
 replace t2=1/5     if bquart==tq(1939q2)
 replace t3=4/5     if bquart==tq(1939q2)
 replace t3=1       if bquart==tq(1939q3)
 replace t3=1       if bquart==tq(1939q4)
 gen t4=0
 replace t3=4/5     if bquart==tq(1940q1)
 replace t4=1/5     if bquart==tq(1940q1)
 replace t3=3/5     if bquart==tq(1940q2)
 replace t4=2/5     if bquart==tq(1940q2)
 replace t3=2/5     if bquart==tq(1940q3)
 replace t4=3/5     if bquart==tq(1940q3)
 replace t3=1/5     if bquart==tq(1940q4)
 replace t4=4/5     if bquart==tq(1940q4)
 replace t4=1       if bquart==tq(1941q1)
 replace t4=1       if bquart==tq(1941q2)
 gen t5=0
 replace t4=4/5     if bquart==tq(1941q3)
 replace t5=1/5     if bquart==tq(1941q3)
 replace t4=3/5     if bquart==tq(1941q4)
 replace t5=2/5     if bquart==tq(1941q4)
 replace t4=2/5     if bquart==tq(1942q1)
 replace t5=3/5     if bquart==tq(1942q1)
 replace t4=1/5     if bquart==tq(1942q2)
 replace t5=4/5     if bquart==tq(1942q2)
 replace t5=1       if bquart==tq(1942q3)
 replace t5=1       if bquart==tq(1942q4)
 gen t6=0
 replace t5=4/5     if bquart==tq(1943q1)
 replace t6=1/5     if bquart==tq(1943q1)
 replace t5=3/5     if bquart==tq(1943q2)
 replace t6=2/5     if bquart==tq(1943q2)
 replace t5=2/5     if bquart==tq(1943q3)
 replace t6=3/5     if bquart==tq(1943q3)
 replace t5=1/5     if bquart==tq(1943q4)
 replace t6=4/5     if bquart==tq(1943q4)
 replace t6=1       if bquart==tq(1944q1)
 replace t6=1       if bquart==tq(1944q2)
 gen t7=0
 replace t6=4/5     if bquart==tq(1944q3)
 replace t7=1/5     if bquart==tq(1944q3)
 replace t6=3/5     if bquart==tq(1944q4)
 replace t7=2/5     if bquart==tq(1944q4)
 replace t6=2/5     if bquart==tq(1945q1)
 replace t7=3/5     if bquart==tq(1945q1)
 replace t6=1/5     if bquart==tq(1945q2)
 replace t7=4/5     if bquart==tq(1945q2)
 replace t7=1       if bquart==tq(1945q3)
 replace t7=1       if bquart==tq(1945q4)
 gen t8=0
 replace t7=4/5     if bquart==tq(1946q1)
 replace t8=1/5     if bquart==tq(1946q1)
 replace t7=3/5     if bquart==tq(1946q2)
 replace t8=2/5     if bquart==tq(1946q2)
 replace t7=2/5     if bquart==tq(1946q3)
 replace t8=3/5     if bquart==tq(1946q3)
 replace t7=1/5     if bquart==tq(1946q4)
 replace t8=4/5     if bquart==tq(1946q4)
 replace t8=1       if bquart==tq(1947q1)
 replace t8=1       if bquart==tq(1947q2)
 gen t9=0
 replace t8=4/5     if bquart==tq(1947q3)
 replace t9=1/5     if bquart==tq(1947q3)
 replace t8=3/5     if bquart==tq(1947q4)
 replace t9=2/5     if bquart==tq(1947q4)
 replace t8=2/5     if bquart==tq(1948q1)
 replace t9=3/5     if bquart==tq(1948q1)
 replace t8=1/5     if bquart==tq(1948q2)
 replace t9=4/5     if bquart==tq(1948q2)
 replace t9=1       if bquart==tq(1948q3)
 replace t9=1       if bquart==tq(1948q4)
 gen t10=0
 replace  t9=4/5    if bquart==tq(1949q1)
 replace t10=1/5    if bquart==tq(1949q1)
 replace  t9=3/5    if bquart==tq(1949q2)
 replace t10=2/5    if bquart==tq(1949q2)
 replace  t9=2/5    if bquart==tq(1949q3)
 replace t10=3/5    if bquart==tq(1949q3)
 replace  t9=1/5    if bquart==tq(1949q4)
 replace t10=4/5    if bquart==tq(1949q4)
 replace t10=1      if bquart==tq(1950q1)
 replace t10=1      if bquart>=tq(1950q2)
 gen  afcohort=(dt1)
 replace afcohort=1 if(dt2>0 | dt3>0 |dt4>0 |dt5>0)
 gen bfcohort=(1-afcohort)
 gen b29_J35=bfcohort
 gen bJ35_J41=dt1+dt2
 gen bJ41_J47=dt3+dt4
 gen bJ47_J52=dt5
 gen ftreat=fem*afcohort
 foreach v in dt1 dt2 dt3 dt4 dt5{
 gen fem`v'=fem*(`v')
 }
 foreach v in dt1 dt2 dt3 dt4 dt5{
 gen men`v'=male*(`v')
 }
 foreach v in 60 61 62 63 64 {
 gen femdt1_`v'=femdt1*(age==`v')
 gen femdt2_`v'=femdt2*(age==`v')
 gen femdt3_`v'=femdt3*(age==`v')
 gen femdt4_`v'=femdt4*(age==`v')
 gen femdt5_`v'=femdt5*(age==`v')
}
 foreach v in 60 61 62 63 64 {
 gen mendt1_`v'=mendt1*(age==`v')
 gen mendt2_`v'=mendt2*(age==`v')
 gen mendt3_`v'=mendt3*(age==`v')
 gen mendt4_`v'=mendt4*(age==`v')
 gen mendt5_`v'=mendt5*(age==`v')
}
 foreach v in 60 61 62 63 64 {
 gen alldt1_`v'=dt1*(age==`v')
 gen alldt2_`v'=dt2*(age==`v')
 gen alldt3_`v'=dt3*(age==`v')
 gen alldt4_`v'=dt4*(age==`v')
 gen alldt5_`v'=dt5*(age==`v')
}
gen ua_apa=0
replace ua_apa=1 if bfcohort==1
replace ua_apa=1 if t1>0 &age>=61
replace ua_apa=1 if t2>0 &age>=62
replace ua_apa=1 if t3>0 &age>=62
replace ua_apa=1 if t4>0 &age>=63
replace ua_apa=1 if t5>0 &age>=63
replace ua_apa=1 if t6>0 &age>=64
replace ua_apa=1 if t7>0 &age>=64
gen forwom=ua_apa==1 & fem==1 & sage==1
gen formen=age==6569 & fem==0
gen forall=formen==1 |forwom==1

keep for* all* mend* femd* b29_J35 bJ35_J41 bJ41_J47 bJ47_J52 dt* ftreat bfcohort afcohort fem male byearv2  owner owner_nomor anygovmon_napa anygovmon dispension agepension part edu* hval state_p single sage iu_per hage* 


**************************************************************
***************** LABELING VARIABLES *************************

  label variable hage1  "Age==60" 
  label variable hage2  "Age==61"
  label variable hage3  "Age==62"
  label variable hage4  "Age==63"
  label variable hage5  "Age==64" 
  label variable sage   "60<=Age=<64"
  label variable iu_per "#of person in Income Unit"
  label variable single "Single"
  label variable state  "State of Residence"
  label variable hval   "House Price Estimated" 
  label variable edu1   "Education No Postschool"
  label variable edu2   "Education Bachelor+"
  label variable edu3   "Education Other"
  label variable part   "LFSP==1"
  label variable agepension   "Recieve Age Pension"
  label variable dispension   "Recieve Disability "
  label variable anygovmon    "Recieve Money from Gov Programs"
  label variable anygovmon_napa    "Recieve Money from Gov Programs except Age Pension"
  label variable owner_nomor  "Home owner without mortgage"
  label variable owner        "Home owner"
  label variable fem          "Female"
  label variable male         "Male"
  label variable afcohort     "Born after June 1935 "
  label variable bfcohort     "Born before June 1935"
  label variable ftreat "Female X After Cohort"
  label variable dt1 "Age Pension Age 60.5-61 -APA61"
  label variable dt2 "Age Pension Age 61.5-62 -APA62"
  label variable dt3 "Age Pension Age 62.5-63 -APA63"
  label variable dt4 "Age Pension Age 63.5-64 -APA64"
  label variable dt5 "Age Pension Age 64.5-65 -APA65"
  label variable femdt1 "Female X APA61"
  label variable femdt2 "Female X APA62"
  label variable femdt3 "Female X APA63"
  label variable femdt4 "Female X APA64"
  label variable femdt5 "Female X APA65"
  label variable mendt1 "Male X APA61"
  label variable mendt2 "Male X APA62"
  label variable mendt3 "Male X APA63"
  label variable mendt4 "Male X APA64"
  label variable mendt5 "Male X APA65"
  label variable b29_J35 "Born 1929 to June 1935"
  label variable bJ35_J41 "Born July 1935 to June 1941"
  label variable bJ41_J47 "Born July 1941 to June 1947" 
  label variable bJ47_J52 "Born after June 1947" 
  label variable femdt1_60 "Female X APA61 X 60"
  label variable femdt1_61 "Female X APA61 X 61"
  label variable femdt1_62 "Female X APA61 X 62"
  label variable femdt1_63 "Female X APA61 X 63"
  label variable femdt1_64 "Female X APA61 X 64"
  label variable femdt2_60 "Female X APA62 X 60"
  label variable femdt2_61 "Female X APA62 X 61"
  label variable femdt2_62 "Female X APA62 X 62"
  label variable femdt2_63 "Female X APA62 X 63"
  label variable femdt2_64 "Female X APA62 X 64"
  label variable femdt3_60 "Female X APA63 X 60"
  label variable femdt3_61 "Female X APA63 X 61"
  label variable femdt3_62 "Female X APA63 X 62"
  label variable femdt3_63 "Female X APA63 X 63"
  label variable femdt3_64 "Female X APA63 X 64"
  label variable femdt4_60 "Female X APA64 X 60"
  label variable femdt4_61 "Female X APA64 X 61"
  label variable femdt4_62 "Female X APA64 X 62"
  label variable femdt4_63 "Female X APA64 X 63"
  label variable femdt4_64 "Female X APA64 X 64"
  label variable femdt5_60 "Female X APA65 X 60"
  label variable femdt5_61 "Female X APA65 X 61"
  label variable femdt5_62 "Female X APA65 X 62"
  label variable femdt5_63 "Female X APA65 X 63"
  label variable femdt5_64 "Female X APA65 X 64"
  label variable mendt1_60 "Male X APA61 X 60"
  label variable mendt1_61 "Male X APA61 X 61"
  label variable mendt1_62 "Male X APA61 X 62"
  label variable mendt1_63 "Male X APA61 X 63"
  label variable mendt1_64 "Male X APA61 X 64"
  label variable mendt2_60 "Male X APA62 X 60"
  label variable mendt2_61 "Male X APA62 X 61"
  label variable mendt2_62 "Male X APA62 X 62"
  label variable mendt2_63 "Male X APA62 X 63"
  label variable mendt2_64 "Male X APA62 X 64"
  label variable mendt3_60 "Male X APA63 X 60"
  label variable mendt3_61 "Male X APA63 X 61"
  label variable mendt3_62 "Male X APA63 X 62"
  label variable mendt3_63 "Male X APA63 X 63"
  label variable mendt3_64 "Male X APA63 X 64"
  label variable mendt4_60 "Male X APA64 X 60"
  label variable mendt4_61 "Male X APA64 X 61"
  label variable mendt4_62 "Male X APA64 X 62"
  label variable mendt4_63 "Male X APA64 X 63"
  label variable mendt4_64 "Male X APA64 X 64"
  label variable mendt5_60 "Male X APA65 X 60"
  label variable mendt5_61 "Male X APA65 X 61"
  label variable mendt5_62 "Male X APA65 X 62"
  label variable mendt5_63 "Male X APA65 X 63"
  label variable mendt5_64 "Male X APA65 X 64"
  label variable alldt1_60 " APA61 X 60"
  label variable alldt1_61 " APA61 X 61"
  label variable alldt1_62 " APA61 X 62"
  label variable alldt1_63 " APA61 X 63"
  label variable alldt1_64 " APA61 X 64"
  label variable alldt2_60 " APA62 X 60"
  label variable alldt2_61 " APA62 X 61"
  label variable alldt2_62 " APA62 X 62"
  label variable alldt2_63 " APA62 X 63"
  label variable alldt2_64 " APA62 X 64"
  label variable alldt3_60 " APA63 X 60"
  label variable alldt3_61 " APA63 X 61"
  label variable alldt3_62 " APA63 X 62"
  label variable alldt3_63 " APA63 X 63"
  label variable alldt3_64 " APA63 X 64"
  label variable alldt4_60 " APA64 X 60"
  label variable alldt4_61 " APA64 X 61"
  label variable alldt4_62 " APA64 X 62"
  label variable alldt4_63 " APA64 X 63"
  label variable alldt4_64 " APA64 X 64"
  label variable alldt5_60 " APA65 X 60"
  label variable alldt5_61 " APA65 X 61"
  label variable alldt5_62 " APA65 X 62"
  label variable alldt5_63 " APA65 X 63"
  label variable alldt5_64 " APA65 X 64"

  
  
**************************************************************
*********************** TABLE 2*******************************

foreach v in age edu2 single iu_per owner owner_nomor part  anygovmon dispension {
   reg `v' fem male if sage==1, noconstant
   reg `v' b29_J35 bJ35_J41 bJ41_J47 bJ47_J52 if fem==0 & sage==1, noconstant
   reg `v' b29_J35 bJ35_J41 bJ41_J47 bJ47_J52 if fem==1 & sage==1, noconstant
}
foreach v in age edu2  iu_per owner owner_nomor part  anygovmon dispension {
   reg `v' fem male if single==1 & sage==1 , noconstant
   reg `v' b29_J35 bJ35_J41 bJ41_J47 bJ47_J52 if single==1 & fem==0 & sage==1, noconstant
   reg `v' b29_J35 bJ35_J41 bJ41_J47 bJ47_J52 if single==1 & fem==1 & sage==1, noconstant
}


**************************************************************
*********************** TABLE 3*******************************

reg part ftreat fem   afcohort hage1 hage2 hage3 hage4 hage5  single  edu2 edu3 i.state_p iu_per if sage==1 , noconstant  vce(bs, reps(999))
reg part ftreat fem   afcohort hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per if sage==1 & single==1 , noconstant  vce(bs, reps(999))

qui reg agepension  fem single  edu2 edu3 i.state_p iu_per i.byearv2 owner owner_nomor hval if forall==1 ,  vce(bs, reps(999))
predict yhatall if sage==1
reg yhatall , vce(bs, reps(999))
gen pp1=_b[_cons]
drop yhatall
reg part ftreat fem   afcohort hage1 hage2 hage3 hage4 hage5  single  edu2 edu3 i.state_p iu_per if sage==1 , noconstant  vce(bs, reps(999))
nlcom (cte1: _b[ftreat]/pp1)
qui reg agepension  fem    edu2 edu3 i.state_p iu_per   owner owner_nomor hval if forall==1 &single==1,  vce(bs, reps(999))
predict yhatall if sage==1 &single==1
reg yhatall ,vce(bs, reps(999))
gen pp2=_b[_cons] 
reg part ftreat fem   afcohort hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per if sage==1 & single==1 , noconstant  vce(bs, reps(999))
nlcom (cte2: _b[ftreat]/pp2)



**************************************************************
*********************** TABLE 4*******************************

reg part femdt1 femdt2 femdt3 femdt4 femdt5 fem dt1 dt2 dt3 dt4 dt5 hage1 hage2 hage3 hage4 hage5 edu1 edu2 i.state_p iu_per single if  sage==1 , noconstant vce(bs, reps(999))
reg part femdt1 femdt2 femdt3 femdt4 femdt5 fem dt1 dt2 dt3 dt4 dt5 hage1 hage2 hage3 hage4 hage5 edu1 edu2 i.state_p iu_per   if  sage==1 &single==1, noconstant vce(bs, reps(999))
reg part femdt1 femdt2 femdt3 femdt4 femdt5 fem dt1 dt2 dt3 dt4 dt5 hage1 hage2 hage3 hage4 hage5 edu1 edu2 i.state_p iu_per   if  sage==1 &single==1 &owner_nomor==1, noconstant vce(bs, reps(999))
reg part femdt1 femdt2 femdt3 femdt4 femdt5 fem dt1 dt2 dt3 dt4 dt5 hage1 hage2 hage3 hage4 hage5 i.state_p iu_per   if  sage==1 &single==1 & edu2==1, noconstant vce(bs, reps(999))

drop yhatall
reg agepension  fem   single  edu2 edu3 i.state_p iu_per   owner owner_nomor hval if forall==1,   vce(bs, reps(999))
predict yhatall if sage==1
reg yhatall dt1 dt2 dt3 dt4 dt5 if sage==1  , noconstant 
qui{
gen pp3_dt1=_b[dt1]
gen pp3_dt2=_b[dt2]
gen pp3_dt3=_b[dt3]
gen pp3_dt4=_b[dt4]
gen pp3_dt5=_b[dt5]
}

reg part femdt1 femdt2 femdt3 femdt4 femdt5 fem dt1 dt2 dt3 dt4 dt5 hage1 hage2 hage3 hage4 hage5 edu1 edu2 i.state_p iu_per single if  sage==1 , noconstant vce(bs, reps(999))
nlcom  (c_dt1: _b[femdt1]/pp3_dt1)  (c_dt2: _b[femdt2]/pp3_dt2)  (c_dt3: _b[femdt3]/pp3_dt3) (c_dt4: _b[femdt4]/pp3_dt4) (c_dt5: _b[femdt5]/pp3_dt5)


drop yhatall
reg agepension  fem   edu2 edu3 i.state_p iu_per   owner owner_nomor hval if forall==1 &single==1,   vce(bs, reps(999))
predict yhatall if sage==1 & single==1
reg yhatall dt1 dt2 dt3 dt4 dt5 if sage==1 & single==1 , noconstant 
qui{
gen pp4_dt1=_b[dt1]
gen pp4_dt2=_b[dt2]
gen pp4_dt3=_b[dt3]
gen pp4_dt4=_b[dt4]
gen pp4_dt5=_b[dt5]
}

reg part femdt1 femdt2 femdt3 femdt4 femdt5 fem dt1 dt2 dt3 dt4 dt5 hage1 hage2 hage3 hage4 hage5 edu1 edu2 i.state_p iu_per   if  sage==1 &single==1, noconstant vce(bs, reps(999))
nlcom  (c_dt1: _b[femdt1]/pp4_dt1)  (c_dt2: _b[femdt2]/pp4_dt2)  (c_dt3: _b[femdt3]/pp4_dt3) (c_dt4: _b[femdt4]/pp4_dt4) (c_dt5: _b[femdt5]/pp4_dt5)

drop yhatall
reg agepension  fem    edu2 edu3 i.state_p iu_per    hval if forall==1 &single==1 & owner_nomor==1 ,   vce(bs, reps(999))
predict yhatall if sage==1 &single==1 & owner_nomor==1
reg yhatall dt1 dt2 dt3 dt4 dt5 if sage==1 &single==1 & owner_nomor==1  , noconstant 
qui{
gen pp5_dt1=_b[dt1]
gen pp5_dt2=_b[dt2]
gen pp5_dt3=_b[dt3]
gen pp5_dt4=_b[dt4]
gen pp5_dt5=_b[dt5]
}

reg part femdt1 femdt2 femdt3 femdt4 femdt5 fem dt1 dt2 dt3 dt4 dt5 hage1 hage2 hage3 hage4 hage5 edu1 edu2 i.state_p iu_per   if  sage==1 &single==1 & owner_nomor==1, noconstant vce(bs, reps(999))
nlcom  (c_dt1: _b[femdt1]/pp5_dt1)  (c_dt2: _b[femdt2]/pp5_dt2)  (c_dt3: _b[femdt3]/pp5_dt3) (c_dt4: _b[femdt4]/pp5_dt4) (c_dt5: _b[femdt5]/pp5_dt5)

drop yhatall
reg agepension  fem    i.state_p iu_per   owner owner_nomor hval if forall==1 &single==1 & edu2==1,   vce(bs, reps(999))
predict yhatall if sage==1 & single==1 & edu2==1
reg yhatall dt1 dt2 dt3 dt4 dt5 if sage==1 & single==1  & edu2==1 , noconstant 
qui{
gen pp6_dt1=_b[dt1]
gen pp6_dt2=_b[dt2]
gen pp6_dt3=_b[dt3]
gen pp6_dt4=_b[dt4]
gen pp6_dt5=_b[dt5]
}
reg part femdt1 femdt2 femdt3 femdt4 femdt5 fem dt1 dt2 dt3 dt4 dt5 hage1 hage2 hage3 hage4 hage5  i.state_p iu_per   if  sage==1 & single==1 & edu2==1, noconstant vce(bs, reps(999))
nlcom  (c_dt1: _b[femdt1]/pp6_dt1)  (c_dt2: _b[femdt2]/pp6_dt2)  (c_dt3: _b[femdt3]/pp6_dt3) (c_dt4: _b[femdt4]/pp6_dt4) (c_dt5: _b[femdt5]/pp6_dt5)




**************************************************************
*********************** TABLE 5*******************************
 reg part  mendt1_60 mendt1_61 mendt1_62 mendt1_63 mendt1_64  mendt2_60 mendt2_61 mendt2_62 mendt2_63 mendt2_64 mendt3_60 mendt3_61 mendt3_62 mendt3_63 mendt3_64 mendt4_60 mendt4_61 mendt4_62 mendt4_63 mendt4_64 mendt5_60 mendt5_61 mendt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==0 & sage==1, noconstant vce(bs, reps(999))
 nlcom  (first: _b[mendt1_60]+_b[mendt1_61]+_b[mendt1_62]+_b[mendt1_63]+_b[mendt1_64]) (second: _b[mendt2_60]+_b[mendt2_61]+_b[mendt2_62]+_b[mendt2_63]+_b[mendt2_64])  (third: _b[mendt3_60]+_b[mendt3_61]+_b[mendt3_62]+_b[mendt3_63]+_b[mendt3_64]) (fourth: _b[mendt4_60]+_b[mendt4_61]+_b[mendt4_62]+_b[mendt4_63]+_b[mendt4_64]) (fifth: _b[mendt5_60]+_b[mendt5_61]+_b[mendt5_62]), post
 nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5)


 reg part  femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==1 & sage==1, noconstant vce(bs, reps(999))
 nlcom  (first: _b[femdt1_60]+_b[femdt1_61]+_b[femdt1_62]+_b[femdt1_63]+_b[femdt1_64]) (second: _b[femdt2_60]+_b[femdt2_61]+_b[femdt2_62]+_b[femdt2_63]+_b[femdt2_64])  (third: _b[femdt3_60]+_b[femdt3_61]+_b[femdt3_62]+_b[femdt3_63]+_b[femdt3_64]) (fourth: _b[femdt4_60]+_b[femdt4_61]+_b[femdt4_62]+_b[femdt4_63]+_b[femdt4_64]) (fifth: _b[femdt5_60]+_b[femdt5_61]+_b[femdt5_62]), post
 nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5)
 
 reg part  femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single fem  dt1 dt2 dt3 dt4 dt5 if  sage==1, noconstant vce(bs, reps(999))
 nlcom  (first: _b[femdt1_60]+_b[femdt1_61]+_b[femdt1_62]+_b[femdt1_63]+_b[femdt1_64]) (second: _b[femdt2_60]+_b[femdt2_61]+_b[femdt2_62]+_b[femdt2_63]+_b[femdt2_64])  (third: _b[femdt3_60]+_b[femdt3_61]+_b[femdt3_62]+_b[femdt3_63]+_b[femdt3_64]) (fourth: _b[femdt4_60]+_b[femdt4_61]+_b[femdt4_62]+_b[femdt4_63]+_b[femdt4_64]) (fifth: _b[femdt5_60]+_b[femdt5_61]+_b[femdt5_62]), post
 nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5) 


 drop yhatall
 reg agepension fem single  edu2 edu1 i.state_p iu_per owner owner_nomor hval if forall==1 ,  vce(bs, reps(999))
 predict yhatall if sage==1

 
 reg agepension single  edu2 edu1 i.state_p iu_per owner owner_nomor hval if forwom==1 ,  vce(bs, reps(999))
 predict yhatwom if fem==1 & sage==1


 reg agepension single  edu2 edu1 i.state_p iu_per owner owner_nomor hval if formen==1 ,  vce(bs, reps(999))
 predict yhatmen if fem==0 & sage==1


 reg yhatmen mendt1_60 mendt1_61 mendt1_62 mendt1_63 mendt1_64  mendt2_60 mendt2_61 mendt2_62 mendt2_63 mendt2_64 mendt3_60 mendt3_61 mendt3_62 mendt3_63 mendt3_64 mendt4_60 mendt4_61 mendt4_62 mendt4_63 mendt4_64 mendt5_60 mendt5_61 mendt5_62  if fem==0 & sage==1, noconstant vce(bs, reps(999))
 nlcom  (pp7_dt1:( _b[mendt1_60]+_b[mendt1_61]+_b[mendt1_62]+_b[mendt1_63]+_b[mendt1_64])/5) (pp7_dt2: (_b[mendt2_60]+_b[mendt2_61]+_b[mendt2_62]+_b[mendt2_63]+_b[mendt2_64])/5)  (pp7_dt3: (_b[mendt3_60]+_b[mendt3_61]+_b[mendt3_62]+_b[mendt3_63]+_b[mendt3_64])/5) (pp7_dt4: (_b[mendt4_60]+_b[mendt4_61]+_b[mendt4_62]+_b[mendt4_63]+_b[mendt4_64])/5) (pp7_dt5:( _b[mendt5_60]+_b[mendt5_61]+_b[mendt5_62])/3)

 qui{
  gen first1=_b[mendt1_60]
  gen first2=_b[mendt1_61]
  gen first3=_b[mendt1_62]
  gen first4=_b[mendt1_63]
  gen first5=_b[mendt1_64]
  gen s1=_b[mendt2_60]
  gen s2=_b[mendt2_61]
  gen s3=_b[mendt2_62]
  gen s4=_b[mendt2_63]
  gen s5=_b[mendt2_64]
  gen t1b=_b[mendt3_60]
  gen t2b=_b[mendt3_61]
  gen t3b=_b[mendt3_62]
  gen t4b=_b[mendt3_63]
  gen t5b=_b[mendt3_64]
  gen f1=_b[mendt4_60]
  gen f2=_b[mendt4_61]
  gen f3=_b[mendt4_62]
  gen f4=_b[mendt4_63]
  gen f5=_b[mendt4_64]
  gen five1=_b[mendt5_60]
  gen five2=_b[mendt5_61]
  gen five3=_b[mendt5_62]
  }

 reg part  mendt1_60 mendt1_61 mendt1_62 mendt1_63 mendt1_64  mendt2_60 mendt2_61 mendt2_62 mendt2_63 mendt2_64 mendt3_60 mendt3_61 mendt3_62 mendt3_63 mendt3_64 mendt4_60 mendt4_61 mendt4_62 mendt4_63 mendt4_64 mendt5_60 mendt5_61 mendt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==0 & sage==1, noconstant vce(bs, reps(999))
 nlcom  (c_dt1: _b[mendt1_60]/first1+_b[mendt1_61]/first2+_b[mendt1_62]/first3+_b[mendt1_63]/first4+_b[mendt1_64]/first5) (c_dt2: _b[mendt2_60]/s1+_b[mendt2_61]/s2+_b[mendt2_62]/s3+_b[mendt2_63]/s4+_b[mendt2_64]/s5)  (c_dt3: _b[mendt3_60]/t1b+_b[mendt3_61]/t2b+_b[mendt3_62]/t3b+_b[mendt3_63]/t4b+_b[mendt3_64]/t5b) (c_dt4: _b[mendt4_60]/f1+_b[mendt4_61]/f2+_b[mendt4_62]/f3+_b[mendt4_63]/f4+_b[mendt4_64]/f5) (c_dt5: _b[mendt5_60]/five1+_b[mendt5_61]/five2+_b[mendt5_62]/five3), post
 nlcom ( mc_dt1:(_b[c_dt1]/1+_b[c_dt2]/2+_b[c_dt3]/3+_b[c_dt4]/4+_b[c_dt5]/5)/5)
 drop first1 first2 first3 first4 first5 s1 s2 s3 s4  s5 t1b t2b t3b t4b t5b f1 f2 f3 f4 f5 five1 five2 five3 

 
 reg yhatwom femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62 if fem==1 &sage==1 ,  noconstant vce(bs, reps(999))
 nlcom  (pp8_dt1:( _b[femdt1_60]+_b[femdt1_61]+_b[femdt1_62]+_b[femdt1_63]+_b[femdt1_64])/5) (pp8_dt2: (_b[femdt2_60]+_b[femdt2_61]+_b[femdt2_62]+_b[femdt2_63]+_b[femdt2_64])/5)  (pp8_dt3: (_b[femdt3_60]+_b[femdt3_61]+_b[femdt3_62]+_b[femdt3_63]+_b[femdt3_64])/5) (pp8_dt4: (_b[femdt4_60]+_b[femdt4_61]+_b[femdt4_62]+_b[femdt4_63]+_b[femdt4_64])/5) (pp8_dt5:( _b[femdt5_60]+_b[femdt5_61]+_b[femdt5_62])/3)

 qui{
 gen first1=_b[femdt1_60]
 gen first2=_b[femdt1_61]
 gen first3=_b[femdt1_62]
 gen first4=_b[femdt1_63]
 gen first5=_b[femdt1_64]
 gen s1=_b[femdt2_60]
 gen s2=_b[femdt2_61]
 gen s3=_b[femdt2_62]
 gen s4=_b[femdt2_63]
 gen s5=_b[femdt2_64]
 gen t1b=_b[femdt3_60]
 gen t2b=_b[femdt3_61]
 gen t3b=_b[femdt3_62]
 gen t4b=_b[femdt3_63]
 gen t5b=_b[femdt3_64]
 gen f1=_b[femdt4_60]
 gen f2=_b[femdt4_61]
 gen f3=_b[femdt4_62]
 gen f4=_b[femdt4_63]
 gen f5=_b[femdt4_64]
 gen five1=_b[femdt5_60]
 gen five2=_b[femdt5_61]
 gen five3=_b[femdt5_62]
}
  reg part  femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==1 & sage==1,  noconstant vce(bs, reps(999))
  nlcom  (c_dt1: _b[femdt1_60]/first1+_b[femdt1_61]/first2+_b[femdt1_62]/first3+_b[femdt1_63]/first4+_b[femdt1_64]/first5) (c_dt2: _b[femdt2_60]/s1+_b[femdt2_61]/s2+_b[femdt2_62]/s3+_b[femdt2_63]/s4+_b[femdt2_64]/s5)  (c_dt3: _b[femdt3_60]/t1b+_b[femdt3_61]/t2b+_b[femdt3_62]/t3b+_b[femdt3_63]/t4b+_b[femdt3_64]/t5b) (c_dt4: _b[femdt4_60]/f1+_b[femdt4_61]/f2+_b[femdt4_62]/f3+_b[femdt4_63]/f4+_b[femdt4_64]/f5) (c_dt5: _b[femdt5_60]/five1+_b[femdt5_61]/five2+_b[femdt5_62]/five3), post
  nlcom ( mc_dt1:(_b[c_dt1]/1+_b[c_dt2]/2+_b[c_dt3]/3+_b[c_dt4]/4+_b[c_dt5]/5)/5)
  drop first1 first2 first3 first4 first5 s1 s2 s3 s4  s5 t1b t2b t3b t4b t5b f1 f2 f3 f4 f5 five1 five2 five3 

 
  reg yhatall alldt1_60 alldt1_61 alldt1_62 alldt1_63 alldt1_64  alldt2_60 alldt2_61 alldt2_62 alldt2_63 alldt2_64 alldt3_60 alldt3_61 alldt3_62 alldt3_63 alldt3_64 alldt4_60 alldt4_61 alldt4_62 alldt4_63 alldt4_64 alldt5_60 alldt5_61 alldt5_62  if sage==1 ,  noconstant vce(bs, reps(999))
  nlcom  (pp9_dt1:( _b[alldt1_60]+_b[alldt1_61]+_b[alldt1_62]+_b[alldt1_63]+_b[alldt1_64])/5) (pp9_dt2: (_b[alldt2_60]+_b[alldt2_61]+_b[alldt2_62]+_b[alldt2_63]+_b[alldt2_64])/5)  (pp9_dt3: (_b[alldt3_60]+_b[alldt3_61]+_b[alldt3_62]+_b[alldt3_63]+_b[alldt3_64])/5) (pp9_dt4: (_b[alldt4_60]+_b[alldt4_61]+_b[alldt4_62]+_b[alldt4_63]+_b[alldt4_64])/5) (pp9_dt5:( _b[alldt5_60]+_b[alldt5_61]+_b[alldt5_62])/3)

 qui{
 gen first1=_b[alldt1_60]
 gen first2=_b[alldt1_61]
 gen first3=_b[alldt1_62]
 gen first4=_b[alldt1_63]
 gen first5=_b[alldt1_64]
 gen s1=_b[alldt2_60]
 gen s2=_b[alldt2_61]
 gen s3=_b[alldt2_62]
 gen s4=_b[alldt2_63]
 gen s5=_b[alldt2_64]
 gen t1b=_b[alldt3_60]
 gen t2b=_b[alldt3_61]
 gen t3b=_b[alldt3_62]
 gen t4b=_b[alldt3_63]
 gen t5b=_b[alldt3_64]
 gen f1=_b[alldt4_60]
 gen f2=_b[alldt4_61]
 gen f3=_b[alldt4_62]
 gen f4=_b[alldt4_63]
 gen f5=_b[alldt4_64]
 gen five1=_b[alldt5_60]
 gen five2=_b[alldt5_61]
 gen five3=_b[alldt5_62]
}
 
 reg part  femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single fem  dt1 dt2 dt3 dt4 dt5 if  sage==1, noconstant vce(bs, reps(999))
 nlcom  (c_dt1: _b[femdt1_60]/first1+_b[femdt1_61]/first2+_b[femdt1_62]/first3+_b[femdt1_63]/first4+_b[femdt1_64]/first5) (c_dt2: _b[femdt2_60]/s1+_b[femdt2_61]/s2+_b[femdt2_62]/s3+_b[femdt2_63]/s4+_b[femdt2_64]/s5)  (c_dt3: _b[femdt3_60]/t1b+_b[femdt3_61]/t2b+_b[femdt3_62]/t3b+_b[femdt3_63]/t4b+_b[femdt3_64]/t5b) (c_dt4: _b[femdt4_60]/f1+_b[femdt4_61]/f2+_b[femdt4_62]/f3+_b[femdt4_63]/f4+_b[femdt4_64]/f5) (c_dt5: _b[femdt5_60]/five1+_b[femdt5_61]/five2+_b[femdt5_62]/five3), post
 nlcom ( mc_dt1:(_b[c_dt1]/1+_b[c_dt2]/2+_b[c_dt3]/3+_b[c_dt4]/4+_b[c_dt5]/5)/5)
 drop first1 first2 first3 first4 first5 s1 s2 s3 s4  s5 t1b t2b t3b t4b t5b f1 f2 f3 f4 f5 five1 five2 five3


 
**************************************************************
*********************** TABLE 6*******************************

 reg anygovmon  mendt1_60 mendt1_61 mendt1_62 mendt1_63 mendt1_64  mendt2_60 mendt2_61 mendt2_62 mendt2_63 mendt2_64 mendt3_60 mendt3_61 mendt3_62 mendt3_63 mendt3_64 mendt4_60 mendt4_61 mendt4_62 mendt4_63 mendt4_64 mendt5_60 mendt5_61 mendt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==0 & sage==1, noconstant vce(bs, reps(999))
 nlcom  (first: _b[mendt1_60]+_b[mendt1_61]+_b[mendt1_62]+_b[mendt1_63]+_b[mendt1_64]) (second: _b[mendt2_60]+_b[mendt2_61]+_b[mendt2_62]+_b[mendt2_63]+_b[mendt2_64])  (third: _b[mendt3_60]+_b[mendt3_61]+_b[mendt3_62]+_b[mendt3_63]+_b[mendt3_64]) (fourth: _b[mendt4_60]+_b[mendt4_61]+_b[mendt4_62]+_b[mendt4_63]+_b[mendt4_64]) (fifth: _b[mendt5_60]+_b[mendt5_61]+_b[mendt5_62]), post
 nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5)


reg anygovmon  femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==1 & sage==1, noconstant vce(bs, reps(999))
nlcom  (first: _b[femdt1_60]+_b[femdt1_61]+_b[femdt1_62]+_b[femdt1_63]+_b[femdt1_64]) (second: _b[femdt2_60]+_b[femdt2_61]+_b[femdt2_62]+_b[femdt2_63]+_b[femdt2_64])  (third: _b[femdt3_60]+_b[femdt3_61]+_b[femdt3_62]+_b[femdt3_63]+_b[femdt3_64]) (fourth: _b[femdt4_60]+_b[femdt4_61]+_b[femdt4_62]+_b[femdt4_63]+_b[femdt4_64]) (fifth: _b[femdt5_60]+_b[femdt5_61]+_b[femdt5_62]), post
nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5)

 reg  anygovmon_napa  femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==1 & sage==1, noconstant vce(bs, reps(999))
nlcom  (first: _b[femdt1_60]+_b[femdt1_61]+_b[femdt1_62]+_b[femdt1_63]+_b[femdt1_64]) (second: _b[femdt2_60]+_b[femdt2_61]+_b[femdt2_62]+_b[femdt2_63]+_b[femdt2_64])  (third: _b[femdt3_60]+_b[femdt3_61]+_b[femdt3_62]+_b[femdt3_63]+_b[femdt3_64]) (fourth: _b[femdt4_60]+_b[femdt4_61]+_b[femdt4_62]+_b[femdt4_63]+_b[femdt4_64]) (fifth: _b[femdt5_60]+_b[femdt5_61]+_b[femdt5_62]), post
nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5)


**************************************************************
*********************** TABLE 7*******************************
 reg dispension  mendt1_60 mendt1_61 mendt1_62 mendt1_63 mendt1_64  mendt2_60 mendt2_61 mendt2_62 mendt2_63 mendt2_64 mendt3_60 mendt3_61 mendt3_62 mendt3_63 mendt3_64 mendt4_60 mendt4_61 mendt4_62 mendt4_63 mendt4_64 mendt5_60 mendt5_61 mendt5_62  hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==0 & sage==1, noconstant vce(bs, reps(999))
 nlcom  (first: _b[mendt1_60]+_b[mendt1_61]+_b[mendt1_62]+_b[mendt1_63]+_b[mendt1_64]) (second: _b[mendt2_60]+_b[mendt2_61]+_b[mendt2_62]+_b[mendt2_63]+_b[mendt2_64])  (third: _b[mendt3_60]+_b[mendt3_61]+_b[mendt3_62]+_b[mendt3_63]+_b[mendt3_64]) (fourth: _b[mendt4_60]+_b[mendt4_61]+_b[mendt4_62]+_b[mendt4_63]+_b[mendt4_64]) (fifth: _b[mendt5_60]+_b[mendt5_61]+_b[mendt5_62] ), post
 nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5)


 reg dispension  femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==1 & sage==1, noconstant vce(bs, reps(999))
 nlcom  (first: _b[femdt1_60]+_b[femdt1_61]+_b[femdt1_62]+_b[femdt1_63]+_b[femdt1_64]) (second: _b[femdt2_60]+_b[femdt2_61]+_b[femdt2_62]+_b[femdt2_63]+_b[femdt2_64])  (third: _b[femdt3_60]+_b[femdt3_61]+_b[femdt3_62]+_b[femdt3_63]+_b[femdt3_64]) (fourth: _b[femdt4_60]+_b[femdt4_61]+_b[femdt4_62]+_b[femdt4_63]+_b[femdt4_64]) (fifth: _b[femdt5_60]+_b[femdt5_61]+_b[femdt5_62]), post
 nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5)

 reg  dispension  femdt1_60 femdt1_61 femdt1_62 femdt1_63 femdt1_64  femdt2_60 femdt2_61 femdt2_62 femdt2_63 femdt2_64 femdt3_60 femdt3_61 femdt3_62 femdt3_63 femdt3_64 femdt4_60 femdt4_61 femdt4_62 femdt4_63 femdt4_64 femdt5_60 femdt5_61 femdt5_62   hage1 hage2 hage3 hage4 hage5  edu2 edu3 i.state_p iu_per single if fem==1 & sage==1 &single==1, noconstant vce(bs, reps(999))
 nlcom  (first: _b[femdt1_60]+_b[femdt1_61]+_b[femdt1_62]+_b[femdt1_63]+_b[femdt1_64]) (second: _b[femdt2_60]+_b[femdt2_61]+_b[femdt2_62]+_b[femdt2_63]+_b[femdt2_64])  (third: _b[femdt3_60]+_b[femdt3_61]+_b[femdt3_62]+_b[femdt3_63]+_b[femdt3_64]) (fourth: _b[femdt4_60]+_b[femdt4_61]+_b[femdt4_62]+_b[femdt4_63]+_b[femdt4_64]) (fifth: _b[femdt5_60]+_b[femdt5_61]+_b[femdt5_62] ), post
 nlcom ( ratio1:(_b[first]/1+_b[second]/2+_b[third]/3+_b[fourth]/4+_b[fifth]/5)/5)


exit
