clear
set more off
set ty double

set ty double
set more off

set obs 15000
gen r=.
save store, replace

u admit.dta, clear
global f=1.0
gen A=accept
gen aa=male
replace male=indep
replace indep=aa
drop aa

gen ngcsescore=0
qui summ gcsescore if male==1
qui replace ngcsescore=(gcsescore-r(mean))/r(sd) if male==1
qui summ gcsescore if male==0
qui replace ngcsescore=(gcsescore-r(mean))/r(sd) if male==0

gen ntsaoverall=0
qui summ tsaoverall if male==1
qui replace ntsaoverall=(tsaoverall-r(mean))/r(sd) if male==1
qui summ tsaoverall if male==0
qui replace ntsaoverall=(tsaoverall-r(mean))/r(sd) if male==0

gen ncol1av=0
qui summ col1av if male==1
qui replace ncol1av=(col1av-r(mean))/r(sd) if male==1
qui summ col1av if male==0
qui replace ncol1av=(col1av-r(mean))/r(sd) if male==0

gen ntsaessay=0
qui summ tsaessay if male==1
qui replace ntsaessay=(tsaessay-r(mean))/r(sd) if male==1
qui summ tsaessay if male==0
qui replace ntsaessay=(tsaessay-r(mean))/r(sd) if male==0



save temp, replace



*replace male=1-male

summ male
global m=round(r(mean)*r(N))
gsort -male
save temp, replace

*********************************************

gen x1=tsaoverall^2
gen x2=tsaessay
gen x3=tsaessay*tsaoverall
gen x4=tsaessay^2
qreg col1av indep tsaoverall x1 x2 x3 x4 if male==1, quantile(0.50)
qui predict yhatmale, xb
replace yhatmale=. if male==0

qreg col1av indep tsaoverall x1 x2 x3 x4 if male==1, quantile(0.50)
qui predict yhatfem, xb
replace yhatfem=. if male==1

qui summ tsaoverall
global st=r(sd)

qui summ tsaessay
global se=r(sd)


global k=1

global i=1
while $i<=$m {
global j=$m+1

while $j<=_N {
global l=1
global t1=(ntsaoverall[$i]>ntsaoverall[$j]+$f)
global t1=$t1*(ncol1av[$i]>ncol1av[$j]+$f)
global t1=$t1*(ngcsescore[$i]>ngcsescore[$j]+$f)
global t1=$t1*(male[$i]==1)*(male[$j]==0)

global a=yhatmale[$i]
global b=yhatfem[$j]
*macro lis i j a b

while $t1>0 & $t1~=. & $l<=1 & $k<=15000 {
preserve
u store, clear
qui replace r=$a-$b if _n==$k
qui save store, replace
restore
global k=$k+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}
u store, clear
drop if r==.
ren r indep_state
hist indep_state if indep_state<8, bin(50) saving(g1.gph, replace) ti("delta=1.0")












clear
set more off
set ty double

set ty double
set more off

set obs 15000
gen r=.
save store, replace

*use "C:\Documents and Settings\debopam.bhattacharya\iFolder\shil3152\Default_shil3152\Oxford_discrimination\combined_2007_2008_with_finals_new_version.dta", clear
use "C:\Users\Debopam\iFolder\shil3152\Default_shil3152\Oxford_discrimination\combined_2007_2008_with_finals_new_version.dta", clear
global f=1.25
gen A=accept
drop if year==2010
gen aa=male
replace male=indep
replace indep=aa
drop aa

gen ngcsescore=0
qui summ gcsescore if male==1
qui replace ngcsescore=(gcsescore-r(mean))/r(sd) if male==1
qui summ gcsescore if male==0
qui replace ngcsescore=(gcsescore-r(mean))/r(sd) if male==0

gen ntsaoverall=0
qui summ tsaoverall if male==1
qui replace ntsaoverall=(tsaoverall-r(mean))/r(sd) if male==1
qui summ tsaoverall if male==0
qui replace ntsaoverall=(tsaoverall-r(mean))/r(sd) if male==0

gen ncol1av=0
qui summ col1av if male==1
qui replace ncol1av=(col1av-r(mean))/r(sd) if male==1
qui summ col1av if male==0
qui replace ncol1av=(col1av-r(mean))/r(sd) if male==0

gen ntsaessay=0
qui summ tsaessay if male==1
qui replace ntsaessay=(tsaessay-r(mean))/r(sd) if male==1
qui summ tsaessay if male==0
qui replace ntsaessay=(tsaessay-r(mean))/r(sd) if male==0



save temp, replace



*replace male=1-male

summ male
global m=round(r(mean)*r(N))
gsort -male
save temp, replace

*********************************************

gen x1=tsaoverall^2
gen x2=tsaessay
gen x3=tsaessay*tsaoverall
gen x4=tsaessay^2
qreg col1av indep tsaoverall x1 x2 x3 x4 if male==1, quantile(0.50)
qui predict yhatmale, xb
replace yhatmale=. if male==0

qreg col1av indep tsaoverall x1 x2 x3 x4 if male==1, quantile(0.50)
qui predict yhatfem, xb
replace yhatfem=. if male==1

qui summ tsaoverall
global st=r(sd)

qui summ tsaessay
global se=r(sd)


global k=1

global i=1
while $i<=$m {
global j=$m+1

while $j<=_N {
global l=1
global t1=(ntsaoverall[$i]>ntsaoverall[$j]+$f)
global t1=$t1*(ncol1av[$i]>ncol1av[$j]+$f)
global t1=$t1*(ngcsescore[$i]>ngcsescore[$j]+$f)
global t1=$t1*(male[$i]==1)*(male[$j]==0)

global a=yhatmale[$i]
global b=yhatfem[$j]
*macro lis i j a b

while $t1>0 & $t1~=. & $l<=1 & $k<=15000 {
preserve
u store, clear
qui replace r=$a-$b if _n==$k
qui save store, replace
restore
global k=$k+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}
u store, clear
drop if r==.
ren r male_fem
hist male_fem if male_fem<8, bin(50) saving(g2.gph, replace) ti("delta=1.25")

graph combine g1.gph g2.gph, ti("Monotonicity under Normalized Test-scores")
*******************************************************
