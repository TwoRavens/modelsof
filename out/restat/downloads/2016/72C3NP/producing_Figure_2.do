clear
macro drop all
clear matrix
set more off
set ty double
set matsize 10000
global f=0.1
*qui {
global nn=1
*while $nn<=1 {

u admit, clear

qui gen aa=male
qui replace male=indep
qui replace indep=aa
drop aa
save temp, replace

logit got_in gcsescore tsaessay tsaoverall col1average indep if male==1
qui predict phatmale, p


logit got_in gcsescore tsaessay tsaoverall col1average indep if male==0
qui predict phatfem, p

qui replace phatmale=. if male==0
qui replace phatfem=. if male==1

qui gen phat=.
qui replace phat=phatmale if male==1
qui replace phat=phatfem if male==0

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
qui summ col1av
global si=r(sd)
*********************************************

matrix A=J(10000,1,.)

global k=1
gsort -male
qui summ male
global nk=int(_N*r(mean))
global ll=1
global i=1
while $i<=$nk {
global j=${nk}+1

while $j<=_N {

global l=1
*global t1=(gcsescore[$i]>gcsescore[$j])*(x2[$i]>$f*x2[$j])*(x3[$i]>$f*x3[$j])

global t1=(gcsescore[$i]>gcsescore[$j]+$f*${sg})*(tsaoverall[$i]>tsaoverall[$j]+$f*${st})*(col1av[$i]>col1av[$j]+$f*${si})
global t1=$t1*(male[$i]==1)*(male[$j]==0)*(indep[$i]==indep[$j])
global t2=phat[$i]-phat[$j]

while $t1>0 & $t1~=. & $k<=10000 & $l<=1{

matrix A[$k,1]=${t2}

global k=$k+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}
qui svmat A
drop if A1==0
drop if A1==.


keep A1
gen male=1
rename A1 male_female
save "C:\Users\Debopam\Desktop\Contextual\male_female.dta", replace

******************************
******************************
******************************

clear
macro drop all
clear matrix
set more off
set ty double
set matsize 10000
*qui {
global nn=1
*while $nn<=1 {


*use "I:\Oxford_discrimination\combined_2007_2008_with_finals.dta", clear
*use "C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\combined_2007_2008_with_finals.dta", clear
use "C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\combined_2007_2008_with_finals_new_version.dta", clear

*use "C:\Users\Debopam\iFolder\Default_shil3152\Oxford_discrimination\combined_2007_2008_with_finals_new_version.dta", clear
*use C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Esteban\cleaned_lawdata.dta
use "C:\Users\Debopam\Desktop\Contextual\admission.dta", clear

qui gen aa=male
qui replace male=indep
qui replace indep=aa
drop aa

replace male=1-male

save temp, replace

logit got_in gcsescore tsaessay tsaoverall col1average indep if male==1
qui predict phatmale, p


logit got_in gcsescore tsaessay tsaoverall col1average indep if male==0
qui predict phatfem, p

qui replace phatmale=. if male==0
qui replace phatfem=. if male==1

qui gen phat=.
qui replace phat=phatmale if male==1
qui replace phat=phatfem if male==0

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
qui summ col1av
global si=r(sd)
*********************************************

matrix A=J(10000,1,.)

global k=1
gsort -male
qui summ male
global nk=int(_N*r(mean))
global ll=1
global i=1
while $i<=$nk {
global j=${nk}+1

while $j<=_N {

global l=1
*global t1=(gcsescore[$i]>gcsescore[$j])*(x2[$i]>$f*x2[$j])*(x3[$i]>$f*x3[$j])

global t1=(gcsescore[$i]>gcsescore[$j]+$f*${sg})*(tsaoverall[$i]>tsaoverall[$j]+$f*${st})*(col1av[$i]>col1av[$j]+$f*${si})
global t1=$t1*(male[$i]==1)*(male[$j]==0)*(indep[$i]==indep[$j])
global t2=phat[$i]-phat[$j]

while $t1>0 & $t1~=. & $k<=10000 & $l<=1{

matrix A[$k,1]=${t2}

global k=$k+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}
qui svmat A
drop if A1==0
drop if A1==.


keep A1
rename A1 female_male
gen male=0
save "C:\Users\Debopam\Desktop\Contextual\female_male.dta", replace
append using "C:\Users\Debopam\Desktop\Contextual\male_female.dta"


gen x=-0.1+1.1*_n/_N
kdensity male_female if male==1, at (x) gen(xm ym)
gen indep_state=ym
kdensity female_male if male==0, at (x) gen(xf yf)
gen state_indep=yf
line indep_state state_indep x if x<0.25


cumul male_female if male==1, gen(is)
cumul female_male if male==0, gen(si)
stack is male_female si female_male, into(c temp) wide clear
line is si temp if temp<0.5, sort

summ  male_female female_male, detail
