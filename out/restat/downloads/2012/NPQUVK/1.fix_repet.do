*this file takes confidential micro data on school prgoression 96-00 "uso externo resultados por estudiante ${i}.dta"
*and cleand  and merges them
*save them as fix_repet

clear
set more 1
set memory 500m
program drop _all
global drop _all

macro define dir="C:\temp\repeticion"
macro define dir1="C:\temp\repeticion"


capture program drop cleannow
program define cleannow

capture rename curant$i cursoant
capture rename curact$i cursoact
capture rename cursan$i cursoant
capture rename curssoac$i cursoact
capture rename curso$i cursoant
capture rename cursac$i cursoact

capture rename repite$i repite
capture rename rep$i repite
rename reps$i repsale
rename proms$i promsale
rename prom$i promueve
capture rename promoc$i promueve1
capture rename repet$i repite1
label var sale "ends curso"
capture rename sale$i sale
capture rename parc$i parci$i 
rename parci$i parcial
capture g deser$i=promsale==1 | repsale==1 | sale==1
rename deser$i deserta


rename depen$i depend
capture rename depen$i depend
capture rename fal$i faltas
capture rename falt$i faltas
capture rename faltas$i faltas
rename result$i result
rename sind$i sindatos
capture rename zona$i zona
capture rename pilo1$i piloto

capture replace piloto=tmp
capture rename edada$i edadant
capture g edadant=edad$i-1
capture rename sexo$i sexo
capture rename extrae$i extraedad

g newcursoant=1 if cursoant=="1"
replace newcursoant=1 if  cursoant=="1R"
replace newcursoant=1 if  cursoant=="1EE"
replace newcursoant=1 if  cursoant=="1N"
replace newcursoant=2 if cursoant=="2"
replace newcursoant=2 if cursoant=="2R"
replace newcursoant=2 if  cursoant=="2EE"
replace newcursoant=2 if  cursoant=="2N"
replace newcursoant=2 if  cursoant=="2  !"
replace newcursoant=3 if cursoant=="3"
replace newcursoant=3 if cursoant=="3N"
replace newcursoant=3 if cursoant=="3E"
replace newcursoant=3 if cursoant=="3EE"
replace newcursoant=3 if cursoant=="3R"
replace newcursoant=4 if cursoant=="4"
replace newcursoant=4 if cursoant=="4N"
replace newcursoant=4 if cursoant=="4r>"
replace newcursoant=2 if  cursoant=="4  !"
replace newcursoant=4 if cursoant=="4EE"
replace newcursoant=5 if cursoant=="5BI"
replace newcursoant=5 if cursoant=="5CB"
replace newcursoant=5 if cursoant=="5CI"
replace newcursoant=5 if cursoant=="5EM"
replace newcursoant=5 if cursoant=="5HU"
replace newcursoant=5 if cursoant=="5SH"
replace newcursoant=6 if cursoant=="6  CM"
replace newcursoant=6 if cursoant=="6BIAG"
replace newcursoant=6 if cursoant=="6BIME"
replace newcursoant=6 if cursoant=="6CIAR"
replace newcursoant=6 if cursoant=="6CIIN"
replace newcursoant=6 if cursoant=="6EMCB"
replace newcursoant=6 if cursoant=="6EMCM"
replace newcursoant=6 if cursoant=="6HUDE"
replace newcursoant=6 if cursoant=="6HUEC"
replace newcursoant=6 if cursoant=="6SHCS"
replace newcursoant=6 if cursoant=="6"
replace newcursoant=6 if cursoant=="6??CS"



capture drop newcursoact
g newcursoact=1 if cursoact=="1"
replace newcursoact=1 if  cursoact=="1R"
replace newcursoact=1 if  cursoact=="1EE"
replace newcursoact=1 if  cursoact=="1N"
replace newcursoact=2 if cursoact=="2"
replace newcursoact=2 if cursoact=="2R"
replace newcursoact=2 if  cursoact=="2EE"
replace newcursoact=2 if  cursoact=="2N"
replace newcursoact=2 if  cursoact=="2  !"
replace newcursoact=3 if cursoact=="3"
replace newcursoact=3 if cursoact=="3N"
replace newcursoact=3 if cursoact=="3E"
replace newcursoact=3 if cursoact=="3EE"
replace newcursoact=3 if cursoact=="3R"
replace newcursoact=4 if cursoact=="4"
replace newcursoact=4 if cursoact=="4N"
replace newcursoact=4 if cursoact=="4r>"
replace newcursoact=4 if  cursoact=="4  !"
replace newcursoact=4 if cursoact=="4EE"
replace newcursoact=5 if cursoact=="5BI"
replace newcursoact=5 if cursoact=="5CB"
replace newcursoact=5 if cursoact=="5CI"
replace newcursoact=5 if cursoact=="5EM"
replace newcursoact=5 if cursoact=="5HU"
replace newcursoact=5 if cursoact=="5SH"
replace newcursoact=6 if cursoact=="6  CM"
replace newcursoact=6 if cursoact=="6BIAG"
replace newcursoact=6 if cursoact=="6BIME"
replace newcursoact=6 if cursoact=="6CIAR"
replace newcursoact=6 if cursoact=="6CIIN"
replace newcursoact=6 if cursoact=="6EMCB"
replace newcursoact=6 if cursoact=="6EMCM"
replace newcursoact=6 if cursoact=="6HUDE"
replace newcursoact=6 if cursoact=="6HUEC"
replace newcursoact=6 if cursoact=="6SHCS"
replace newcursoact=6 if cursoact=="6"
replace newcursoact=6 if cursoact=="6??CS"

end

global i=96
while $i<=98 {
use "$dir1\original_data_confidential\sincedula\uso externo resultados por estudiante ${i}.dta", clear
cleannow
sort id
save $dir\created_data_confidential\repet$i, replace
global i=$i+1
}


use "$dir1\original_data_confidential\sincedula\uso externo resultados por estudiante 00.dta", clear
drop pilo00
rename piloto00 pilo100
global i="00"
cleannow
sort id
save $dir\created_data_confidential\repet100, replace


u $dir\created_data_confidential\repet96, replace
g year=96
local i=97
while `i'<=100 {
capture append using "$dir\created_data_confidential\repet`i'.dta"
replace year=`i' if year==.
local i=`i'+1
}

capture drop tmp1
g tmp1=promueve==1 | promsale==1
replace promueve1=tmp1 if year==100
drop promueve
rename promueve1 promueve

capture drop tmp1
g tmp1=repite==1 | repsale==1
replace repite1=tmp1 if year==100
drop repite
rename repite1 repite

rename edada edad
#delimit ;
keep year zona              
id sexo   edad id    
depend piloto
cursoant     newcursoant
cursoact     newcursoact
faltas       
result parcial
repite  
promueve 
sale   deserta       
sindatos    ;
#delimit cr


g tmp=1 if sexo=="F" & year<98
replace tmp=0 if sexo=="M" & year<98
replace tmp=99 if tmp==. 
drop  sex
rename tmp sexo
label define sexo 0 "Male" 1 "Female"  99 "missing"
label values sexo sexo

replace edad=99 if edad<10 | edad>30
g missedad=edad==99
g misssexo=sexo==99

encode cursoant, g(tmp)
drop cursoant
rename tmp cursoant
encode cursoact, g(tmp)
drop  cursoact
rename tmp cursoact

g exit=sale==1 | deserta==1
replace deserta=0 if sale==1

replace promueve=1 if sale==1

global i=96
while $i<=100 {
preserve
keep if year==$i
capture sort id

#delimit ;
for any 
zona              
sexo edad missedad misssexo
depend piloto
cursoant     newcursoant
cursoact     newcursoact
faltas       
result parcial
repite  
promueve 
sale   deserta  exit      
sindatos    
: rename X X${i};
#delimit cr
capture save $dir\created_data_confidential\repet1$i, replace

restore
global i=$i+1
}

u $dir\created_data_confidential\repet196, replace
g pres96=1
sort id
merge id using $dir\created_data_confidential\repet197
rename _m merge9697
g pres97=1 if merge96==2 | merge96==3
sort id
merge id using $dir\created_data_confidential\repet198
rename _m merge9798
g pres98=1 if merge97==2 | merge97==3
sort id
merge id using $dir\created_data_confidential\repet1100
rename _m merge98100
g pres100=1 if merge98==2 | merge98==3

for any 96 97 98  100 : replace presX=0 if presX==.

sort id
compress
save $dir\created_data_confidential\repet, replace



u $dir\created_data_confidential\repet, replace
**********
*keeps only those present sometimes in 1996-1997
**********
keep if pres96+pres97+pres98>0

*sample 10
reshape vars exit deserta sale  pres repite result promueve sindatos faltas edad sexo zona depend piloto newcursoant newcursoact
reshape groups year 96-101
reshape cons id 
drop year
reshape long
replace newcursoant=newcursoant+6
replace newcursoact=newcursoact+6


********
*COMPUTES PRES IN 1999 AND 2001 (CONDITIONAL ON PRES YEAR BEFORE)
*******
sort id year
qui by id: replace pres=newcursoact[_n-1]~=. if year==99
qui by id: replace pres=newcursoact[_n-1]~=. if year==101
qui by id: replace newcursoant=newcursoact[_n-1] if year==99 
qui by id: replace newcursoant=newcursoact[_n-1] if year==101  

*********
*takes only those in CB in 1996-97
*********
g sample=1 if year<=99 & newcursoant<10 
egen maxsa=max(sam), by(id)
drop if maxs~=1
drop maxs 


********
*COMPUTES AGE/SEX IN LATER YEARS FOR THOSE IN SAMPLE IN 1996/7
*******
g edad1=edad if year==96 
egen age=max(edad1), by(id)
replace age=age+year-96
g edad2=edad if year==97 
egen age2=max(edad2), by(id)
replace age=age2+year-97 if age==.
drop age2 edad1 edad2  

replace age=99 if age==. 
replace age=99 if age>90 & age~=.
g missage=age==99

*fix when included sex in 1998
capture drop tmp
g tmp=sexo if year<=97 
egen sex=max(tmp), by(id)
drop tmp
replace sex=99 if sex==.
g misssex=sex==99
drop sexo
rename sex sexo
label values sexo sexo


*********
*FIXES LAST GRADE
***********
*there is a certian number of indviduals in fifth grade whom do **not** repeat, do not sale but the year after they attend the same course. 
*there is also a certian number of indviduals in fifth grade whom do **not** repeat, sale but the year after they attend the same course. 
*i assume that these must be indviduals who have finished thier course of study but have some pending subjects
*i replace thier re-attendance of 5 grade with missing
*careful: these will be classified as sale=0 but in fact they have gone out of system but need to redo exam 
 
***********
sort id pres year
qui by id: g newcursoantlag=newcursoant[_n-1]
qui by id pres: g repitelag=repite[_n-1]
qui by id pres: g salelag=sale[_n-1]
replace newcursoant=. if newcursoantlag==11 & salelag==0 & repitelag==0 & newcursoant==11
replace newcursoant=. if newcursoantlag==11 & salelag==0 & repitelag==0 & newcursoant==11
***********
*there is a certian number of individuals in sixth grade whom *repeat*, do not sale but the year after they attend fifth grade. 
*i assume that these must be indviduals who have finished thier course of study but have some pending subjects
*i replace thier re-attendance of fifth grade with a missing
***********
sort id pres year
replace newcursoant=. if newcursoantlag==12 & newcursoant==11
replace pres=0 if newcursoant==.

*********
*COMPUTES AGE/YEAR AT/OF ENTRY 
********
capture drop tmp
egen tmp=min(year) if pres==1, by(id)
egen yearentry=min(tmp) , by(id)
drop tmp
*drop if year<yearentry




************
*computes present/curso/maxcurso at leads 1-5
**********
sort id year
local i=1
whil `i'<=5 {
qui by id: g pres96`i'=pres[`i'+1] 
qui by id: g pres97`i'=pres[`i'+2] 
qui by id: g pres98`i'=pres[`i'+3] 
qui by id: g pres99`i'=pres[`i'+4] 
local i=`i'+1
}

sort id year
local i=1
whil `i'<=5 {
g pres`i'=pres96`i' if year==96
replace  pres`i'=pres97`i' if year==97
replace  pres`i'=pres98`i' if year==98
replace  pres`i'=pres99`i' if year==99
local i=`i'+1
}
drop pres9*



sort id year
local i=1
whil `i'<=5 {
qui by id: g newcursoant96`i'=newcursoant[`i'+1] 
qui by id: g newcursoant97`i'=newcursoant[`i'+2] 
qui by id: g newcursoant98`i'=newcursoant[`i'+3] 
qui by id: g newcursoant99`i'=newcursoant[`i'+4] 
local i=`i'+1
}


sort id year
local i=1
whil `i'<=5 {
g newcursoant`i'=newcursoant96`i' if year==96
replace  newcursoant`i'=newcursoant97`i' if year==97
replace  newcursoant`i'=newcursoant98`i' if year==98
replace  newcursoant`i'=newcursoant99`i' if year==99
local i=`i'+1
}
drop newcursoant9*

sort id year
local i=1
whil `i'<=5 {
qui by id: g repite96`i'=repite[`i'+1] 
qui by id: g repite97`i'=repite[`i'+2] 
qui by id: g repite98`i'=repite[`i'+3] 
qui by id: g repite99`i'=repite[`i'+4] 
local i=`i'+1
}
sort id year
local i=1
whil `i'<=5 {
g repite`i'=repite96`i' if year==96
replace  repite`i'=repite97`i' if year==97
replace  repite`i'=repite98`i' if year==98
replace  repite`i'=repite99`i' if year==99
local i=`i'+1
}
drop repite9*

sort id year
local i=1
whil `i'<=5 {
qui by id: g faltas96`i'=faltas[`i'+1] 
qui by id: g faltas97`i'=faltas[`i'+2] 
qui by id: g faltas98`i'=faltas[`i'+3] 
qui by id: g faltas99`i'=faltas[`i'+4] 
local i=`i'+1
}
sort id year
local i=1
whil `i'<=5 {
g faltas`i'=faltas96`i' if year==96
replace  faltas`i'=faltas97`i' if year==97
replace  faltas`i'=faltas98`i' if year==98
replace  faltas`i'=faltas99`i' if year==99
local i=`i'+1
}
drop faltas9*


sort id year
local i=1
whil `i'<=5 {
qui by id: g age96`i'=age[`i'+1] 
qui by id: g age97`i'=age[`i'+2] 
qui by id: g age98`i'=age[`i'+3] 
qui by id: g age99`i'=age[`i'+4] 
local i=`i'+1
}

sort id year
local i=1
whil `i'<=5 {
g age`i'=age96`i' if year==96
replace  age`i'=age97`i' if year==97
replace  age`i'=age98`i' if year==98
replace  age`i'=age99`i' if year==99
local i=`i'+1
}
drop age9*

for any 1 2 3 4 5: replace ageX=. if presX==0 
*changing school (conditional on continuous attendance - for reenters might be different)
sort id year
qui by id: g changeschool=depend~=depend[_n-1] if depend~=. & depend[_n-1]~=.


sort id year
local i=1
whil `i'<=5 {
qui by id: g changeschool96`i'=changeschool[`i'+1] 
qui by id: g changeschool97`i'=changeschool[`i'+2] 
qui by id: g changeschool98`i'=changeschool[`i'+3] 
qui by id: g changeschool99`i'=changeschool[`i'+4] 
local i=`i'+1
}
sort id year
local i=1
whil `i'<=5 {
g changeschool`i'=changeschool96`i' if year==96
replace  changeschool`i'=changeschool97`i' if year==97
replace  changeschool`i'=changeschool98`i' if year==98
replace  changeschool`i'=changeschool99`i' if year==99
local i=`i'+1
}
drop changeschool9*



*creates new vartiables and prepares data set for analysys 

**********
*COMPUTES TIME IN SAMPLE/max curso attended by end of period
*********
order newcursoant newcursoant1-newcursoant5
local i=1
whil `i'<=5 {
egen maxnewcursoant`i'=rmax(newcursoant-newcursoant`i') 
local i=`i'+1
}
	
order pres1-pres5
egen dur=rsum(pres1-pres5)  

g maxnewcursoant=maxnewcursoant5

**********
*allows for censoring for repeaters (makes little diff)
********
capture drop dur_cens
g dur_cens=dur 
capture drop tmp
egen tmp=rsum(pres1-pres4)  if year==96 & repite==0
replace dur_cens=tmp if year==96 & repite==0
capture drop tmp
egen tmp=rsum(pres1-pres3)  if year==97 & repite==0
replace dur_cens=tmp if year==97 & repite==0
capture drop tmp
egen tmp=rsum(pres1-pres2)  if year==98 & repite==0
replace dur_cens=tmp if year==98 & repite==0
capture drop tmp
egen tmp=rsum(pres1)  if year==99 & repite==0
replace dur_cens=tmp if year==99 & repite==0


capture drop maxnewcursoant_cens
g maxnewcursoant_cens=maxnewcursoant
replace maxnewcursoant_cens=maxnewcursoant4 if year==96 & repite==0
replace maxnewcursoant_cens=maxnewcursoant3 if year==97 & repite==0
replace maxnewcursoant_cens=maxnewcursoant2 if year==98 & repite==0
replace maxnewcursoant_cens=maxnewcursoant1 if year==99 & repite==0
	
*******
*computes higherst age attended max curso
**********
g maxage=0
for any 1 2 3 4 5: replace maxage=X if newcursoantX==maxnewcursoant
replace maxage=maxage+age
replace maxage=99 if maxage>99

g maxage_cens=0
for any 1 2 3 4 5: replace maxage_cens=X if newcursoantX==maxnewcursoant_cens
replace maxage_cens=maxage_cens+age
replace maxage_cens=99 if maxage_cens>99

g maxdist=maxage-maxnewcursoant
g maxdist_cens=maxage_cens-maxnewcursoant_cens
replace maxdist=99 if maxdist>80 & maxdist~=.
replace maxdist_c=99 if maxdist_c>80 & maxdist_c~=.
********
*rescales faltas
*******
g newfaltas=faltas
replace faltas=faltas-26
g posfaltas=faltas>=0 if faltas~=.

*AGE DISTORTION
g distage=age-newcursoant-5
replace distage=99 if age==99
egen yearnewcursoant=group(year newcursoant)



g cens=pres5 if year==96
replace cens=pres4 if year==97
replace cens=pres3 if year==98
replace cens=pres2 if year==99

g gap=maxnewcursoant-newcursoant
g gap_cens=maxnewcursoant_cens-newcursoant
capture drop tmp*
compress
save $dir\created_data_confidential\fix_repet, replace

