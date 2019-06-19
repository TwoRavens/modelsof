qui {
set more off
clear
clear matrix
set matsize 3000


global f=1.5
matrix drop _all
matrix nkmale=J(100,5,.)
matrix nkfem=J(100,5,.)


set obs 15001
gen sn=.
gen zn=.
gen r=.
global m=1
while $m<=100 {
qui gen Z$m=-1000000000
global m=$m+1
}
save store, replace
u admit, clear
gen aa=male
replace male=indep
replace indep=aa
drop aa

gen c=1
preserve
keep if male==0
logit got_in gcsescore col1av tsaoverall tsaessay
predict phat, p
drop if phat==.

global nfem=_N
matrix A=e(V)
matrix sqrtAfem=cholesky(A)
mkmat gcsescore col1av tsaoverall tsaessay c, matrix(B)
matrix D=B*A*B'
matrix Cf=vecdiag(D)
matrix Cf=Cf'
svmat Cf
save tempfem, replace

restore
keep if male==1
logit got_in gcsescore col1av tsaoverall tsaessay 
predict phat, p
drop if phat==.
global nmale=_N
matrix A=e(V)
matrix sqrtAmale=cholesky(A)
mkmat gcsescore col1av tsaoverall tsaessay c, matrix(B)
matrix D=B*A*B'
matrix Cm=vecdiag(D)
matrix Cm=Cm'
svmat Cm

save tempmale, replace

append using tempfem


qui gen nor=invnorm(uniform())

global n=0
while $n<=99 {
global j=1
while $j<=5 {

matrix nkmale[$n+1,$j]=nor[10*$n+$j]

matrix nkfem[$n+1,$j]=nor[10*$n+$j+5]
global j=$j+1

}
global n=$n+1
}
qui drop nor

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


gsort -male
global v=1

global ll=1
global i=1
while $i<=$nmale & $v<=15001  {

global j=${nmale}+1

while $j<=_N & $v<=15001  {

global l=1

global t1=(ntsaoverall[$i]>ntsaoverall[$j]+$f)
global t1=$t1*(ncol1av[$i]>ncol1av[$j]+$f)
*global t1=$t1*(ngcsescore[$i]>ngcsescore[$j]+$f)
global t1=$t1*(male[$i]==1)*(male[$j]==0)
global t2=ln(phat[$i]/(1-phat[$i]))-ln(phat[$j]/(1-phat[$j]))
global t3=sqrt(Cm1[$i]+Cf1[$j])
matrix xg=(gcsescore[$i],col1av[$i],tsaoverall[$i],tsaessay[$i],c[$i])
matrix xh=(gcsescore[$j],col1av[$j],tsaoverall[$j],tsaessay[$j],c[$j])

matrix z=(xg*sqrtAmale*nkmale'-xh*sqrtAfem*nkfem')/${t3}

while $t1>0 & $t1~=. & $v<=15001 & $l<=1 {


preserve
u store, clear
qui replace r=${t2} if _n==$v
qui replace sn=${t3} if _n==$v
svmat z


global m=1
while $m<=100 {

qui replace Z$m=z$m[1] if _n==$v
global m=$m+1

}
drop z1-z100
save store, replace


restore
global v=$v+1
global l=$l+1
}
global j=$j+1
macro lis j
}
global i=$i+1
macro lis i
}

u store, clear

gen a=.


global m=1
while $m<=100 {
qui summ Z$m
qui replace a=r(max) if _n==$m

global m=$m+1
}
sort a
global k=a[95]
preserve
drop if r==.
qui replace r=r+$k*sn
summ r
global upper=r(min)

restore
replace a=10000000000 if a<-5
sort a

global k=a[3]
drop if r==.
qui replace r=r+$k*sn
summ r
}
global lower=r(min)
dis "ind-state"
macro lis lower upper
*******************************
*******************************
*******************************


qui {
set more off
clear
clear matrix
set matsize 3000


global f=1.5
matrix drop _all
matrix nkmale=J(100,5,.)
matrix nkfem=J(100,5,.)


set obs 15001
gen sn=.
gen zn=.
gen r=.
global m=1
while $m<=100 {
qui gen Z$m=-1000000000
global m=$m+1
}
save store, replace
u admit, clear

gen aa=male
replace male=indep
replace indep=aa
drop aa


replace male=1-male

gen c=1
preserve
keep if male==0
logit got_in gcsescore col1av tsaoverall tsaessay
predict phat, p
drop if phat==.

global nfem=_N
matrix A=e(V)
matrix sqrtAfem=cholesky(A)
mkmat gcsescore col1av tsaoverall tsaessay c, matrix(B)
matrix D=B*A*B'
matrix Cf=vecdiag(D)
matrix Cf=Cf'
svmat Cf
save tempfem, replace

restore
keep if male==1
logit got_in gcsescore col1av tsaoverall tsaessay 
predict phat, p
drop if phat==.
global nmale=_N
matrix A=e(V)
matrix sqrtAmale=cholesky(A)
mkmat gcsescore col1av tsaoverall tsaessay c, matrix(B)
matrix D=B*A*B'
matrix Cm=vecdiag(D)
matrix Cm=Cm'
svmat Cm

save tempmale, replace

append using tempfem


qui gen nor=invnorm(uniform())

global n=0
while $n<=99 {
global j=1
while $j<=5 {

matrix nkmale[$n+1,$j]=nor[10*$n+$j]

matrix nkfem[$n+1,$j]=nor[10*$n+$j+5]
global j=$j+1

}
global n=$n+1
}
qui drop nor

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


gsort -male
global v=1

global ll=1
global i=1
while $i<=$nmale & $v<=15001  {

global j=${nmale}+1

while $j<=_N & $v<=15001  {

global l=1

global t1=(ntsaoverall[$i]>ntsaoverall[$j]+$f)
global t1=$t1*(ncol1av[$i]>ncol1av[$j]+$f)
*global t1=$t1*(ngcsescore[$i]>ngcsescore[$j]+$f)
global t1=$t1*(male[$i]==1)*(male[$j]==0)
global t2=ln(phat[$i]/(1-phat[$i]))-ln(phat[$j]/(1-phat[$j]))
global t3=sqrt(Cm1[$i]+Cf1[$j])
matrix xg=(gcsescore[$i],col1av[$i],tsaoverall[$i],tsaessay[$i],c[$i])
matrix xh=(gcsescore[$j],col1av[$j],tsaoverall[$j],tsaessay[$j],c[$j])

matrix z=(xg*sqrtAmale*nkmale'-xh*sqrtAfem*nkfem')/${t3}

while $t1>0 & $t1~=. & $v<=15001 & $l<=1 {


preserve
u store, clear
qui replace r=${t2} if _n==$v
qui replace sn=${t3} if _n==$v
svmat z


global m=1
while $m<=100 {

qui replace Z$m=z$m[1] if _n==$v
global m=$m+1

}
drop z1-z100
save store, replace


restore
global v=$v+1
global l=$l+1
}
global j=$j+1
macro lis j
}
global i=$i+1
macro lis i
}

u store, clear

gen a=.


global m=1
while $m<=100 {
qui summ Z$m
qui replace a=r(max) if _n==$m

global m=$m+1
}
sort a
global k=a[95]
preserve
drop if r==.
qui replace r=r+$k*sn
summ r
global upper=r(min)

restore
replace a=10000000000 if a<-5
sort a

global k=a[3]
drop if r==.
qui replace r=r+$k*sn
summ r
}
global lower=r(min)
dis "state_indep"
macro lis lower upper
