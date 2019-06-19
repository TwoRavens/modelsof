
clear
set matsize 1000
set more 1
set mem 1000m
program drop _all
macro drop _all


macro define totc="c:\temp\repeticion"
macro define totj="c:\temp\repeticion"

macro define dir="${totc}"
macro define dir1="${totc}"
macro define dir2="${totj}"
macro define dir5="${totj}"
macro define dir6="${totc}"






****************************************************************




	
u "$dir\created_data_confidential\fix_repet", replace
keep if sample==1
keep if pil==0
drop if year>97
sort id year
merge id year using $dir\created_data_confidential\extract_materias
*sample 5
keep if _m==3


replace edad=xedad if year==98
replace edad=99 if edad==.
replace sex=1 if xsex=="F" &  year==98
replace sex=0 if xsex=="M" &  year==98
drop xedad xsex


g intermitt=(pres2==1 | pres3==1| pres4==1 | pres5==1)  if  pres1==1


cap drop dumdu*
cap drop newd*
capture drop dumdu
egen dumdu=rsum(dummy1-dummy9)
cap drop tmp
egen tmp=rsum(missnotamat1-missnotamat9)
replace dumdu=. if tmp>0

capture drop dumdu1
egen dumdu1=rsum(dummy1-dummy11)
cap drop tmp
egen tmp=rsum(missnotamat1-missnotamat11)
replace dumdu=dumdu1 if tmp>0 & newcursoant==9
replace dumdu=. if tmp>0 & newcursoant==9
egen groupid=group(id)
replace id=groupid

keep gap_c repite  dumdu interm pres* age distage newcursoant  sexo  year dep newfaltas notamat1 notamat2 notamat3 notamat4 notamat5 notamat6 notamat7 notamat8 notamat9 notamat10 notamat11  id sample cens
save  $dir\created_data_public\reg_uruguay, replace
