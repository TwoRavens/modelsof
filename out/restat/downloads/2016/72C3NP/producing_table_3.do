

*******************************
*******************************
*******************************
set matsize 3000
qui {
set more off
clear
clear matrix


global f=0
matrix drop _all


u admit.dta, clear
compress


gen c=1
preserve
keep if male==0
logit got_in gcsescore col1av tsaoverall tsaessay
predict phat, p
drop if phat==.
*keep if phat<0.9 & phat>0.1

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

global nn=_N

qui gen nor=invnorm(uniform())

global n=0
global nk=int(($nn-10)/10)
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)

preserve
clear
set obs 15001
gen sn=.
gen zn=.
gen r=.
global m=1
while $m<=$nk {
qui gen Z$m=-1000000000
global m=$m+1
}
qui save store, replace
restore

while $n<=$nk-1 {
global j=1
while $j<=5 {

matrix nkmale[$n+1,$j]=nor[10*$n+$j]

matrix nkfem[$n+1,$j]=nor[10*$n+$j+5]
global j=$j+1

}
global n=$n+1
}
qui drop nor

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
qui summ col1av
global si=r(sd)
qui summ tsaessay
global se=r(sd)
gsort -male
global v=1

global ll=1
global i=1
while $i<=$nmale & $v<=15001  {

global j=${nmale}+1

while $j<=_N & $v<=15001  {

global l=1

global t1=(tsaoverall[$i]>tsaoverall[$j]+$f*${st})
global t1=$t1*(col1av[$i]>col1av[$j]+$f*${si})
global t1=$t1*(gcsescore[$i]>gcsescore[$j]+$f*${sg})
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
while $m<=$nk {

qui replace Z$m=z$m[1] if _n==$v
global m=$m+1

}
drop z1-z$nk
qui save store, replace


restore
global v=$v+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}

u store, clear

gen a=.


global m=1
while $m<=$nk {
qui summ Z$m
qui replace a=r(max) if _n==$m

global m=$m+1
}
sort a
global nn=int(0.95*$nk)
global k=a[$nn]

preserve
drop if r==.
qui replace r=r+$k*sn
summ r
global upper=r(min)

restore
replace a=10000000000 if a<-5
sort a

global nn=int(0.025*$nk)
global k=a[$nn]
drop if r==.
qui replace r=r+$k*sn
summ r
}
global lower=r(min)
dis "male-female"
macro lis lower upper
************
******************
**********************
qui {
set more off
clear
clear matrix


global f=0
matrix drop _all
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)


u admit.dta, clear

replace male=1-male



gen c=1
preserve
keep if male==0
logit got_in gcsescore col1av tsaoverall tsaessay
predict phat, p
drop if phat==.
*keep if phat<0.9 & phat>0.1

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
*keep if phat<0.9 & phat>0.1
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


global nn=_N

qui gen nor=invnorm(uniform())

global n=0
global nk=int(($nn-10)/10)
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)
preserve
clear
set obs 15001
gen sn=.
gen zn=.
gen r=.
global m=1
while $m<=$nk {
qui gen Z$m=-1000000000
global m=$m+1
}
qui save store, replace
restore


while $n<=$nk-1 {
global j=1
while $j<=5 {

matrix nkmale[$n+1,$j]=nor[10*$n+$j]

matrix nkfem[$n+1,$j]=nor[10*$n+$j+5]
global j=$j+1

}
global n=$n+1
}
qui drop nor

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
qui summ col1av
global si=r(sd)
qui summ tsaessay
global se=r(sd)
gsort -male
global v=1

global ll=1
global i=1
while $i<=$nmale & $v<=15001  {

global j=${nmale}+1

while $j<=_N & $v<=15001  {

global l=1

global t1=(tsaoverall[$i]>tsaoverall[$j]+$f*${st})
global t1=$t1*(col1av[$i]>col1av[$j]+$f*${si})
global t1=$t1*(gcsescore[$i]>gcsescore[$j]+$f*${sg})
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
while $m<=$nk {

qui replace Z$m=z$m[1] if _n==$v
global m=$m+1

}
drop z1-z$nk
qui save store, replace


restore
global v=$v+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}

u store, clear

gen a=.


global m=1
while $m<=$nk {
qui summ Z$m
qui replace a=r(max) if _n==$m

global m=$m+1
}
sort a
global nn=int(0.95*$nk)
global k=a[$nn]
preserve
drop if r==.
qui replace r=r+$k*sn
summ r
global upper=r(min)

restore
replace a=10000000000 if a<-5
sort a

global nn=int(0.025*$nk)
global k=a[$nn]
drop if r==.
qui replace r=r+$k*sn
summ r
}
global lower=r(min)
dis "female_male"
macro lis lower upper
**********
****************
************
qui {
set more off
clear
clear matrix


global f=0
matrix drop _all
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)


u admit.dta, clear

gen aa=male
replace male=indep
replace indep=aa

gen c=1
preserve
keep if male==0
logit got_in gcsescore col1av tsaoverall tsaessay
predict phat, p
drop if phat==.
*keep if phat<0.9 & phat>0.1

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
*keep if phat<0.9 & phat>0.1
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


global nn=_N

qui gen nor=invnorm(uniform())

global n=0
global nk=int(($nn-10)/10)
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)
preserve
clear
set obs 15001
gen sn=.
gen zn=.
gen r=.
global m=1
while $m<=$nk {
qui gen Z$m=-1000000000
global m=$m+1
}
qui save store, replace
restore


while $n<=$nk-1 {
global j=1
while $j<=5 {

matrix nkmale[$n+1,$j]=nor[10*$n+$j]

matrix nkfem[$n+1,$j]=nor[10*$n+$j+5]
global j=$j+1

}
global n=$n+1
}

qui drop nor

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
qui summ col1av
global si=r(sd)
qui summ tsaessay
global se=r(sd)
gsort -male
global v=1

global ll=1
global i=1
while $i<=$nmale & $v<=15001  {

global j=${nmale}+1

while $j<=_N & $v<=15001  {

global l=1

global t1=(tsaoverall[$i]>tsaoverall[$j]+$f*${st})
global t1=$t1*(col1av[$i]>col1av[$j]+$f*${si})
global t1=$t1*(gcsescore[$i]>gcsescore[$j]+$f*${sg})
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
while $m<=$nk {

qui replace Z$m=z$m[1] if _n==$v
global m=$m+1

}
drop z1-z$nk
qui save store, replace


restore
global v=$v+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}

u store, clear

gen a=.


global m=1
while $m<=$nk {
qui summ Z$m
qui replace a=r(max) if _n==$m

global m=$m+1
}
sort a
global nn=int(0.95*$nk)
global k=a[$nn]
preserve
drop if r==.
qui replace r=r+$k*sn
summ r
global upper=r(min)

restore
replace a=10000000000 if a<-5
sort a

global nn=int(0.025*$nk)
global k=a[$nn]

drop if r==.
qui replace r=r+$k*sn
summ r
}
global lower=r(min)
dis "indep-state"
macro lis lower upper
*************************
*************************
*************************
qui {
set more off
clear
clear matrix


global f=0
matrix drop _all
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)


u admit.dta, clear
gen aa=male
replace male=indep
replace indep=aa
replace male=1-male

gen c=1
preserve
keep if male==0
logit got_in gcsescore col1av tsaoverall tsaessay
predict phat, p
drop if phat==.
*keep if phat<0.9 & phat>0.1

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
*keep if phat<0.9 & phat>0.1
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


global nn=_N

qui gen nor=invnorm(uniform())

global n=0
global nk=int(($nn-10)/10)
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)
preserve
clear
set obs 15001
gen sn=.
gen zn=.
gen r=.
global m=1
while $m<=$nk {
qui gen Z$m=-1000000000
global m=$m+1
}
qui save store, replace
restore


while $n<=$nk-1 {
global j=1
while $j<=5 {

matrix nkmale[$n+1,$j]=nor[10*$n+$j]

matrix nkfem[$n+1,$j]=nor[10*$n+$j+5]
global j=$j+1

}
global n=$n+1
}
qui drop nor

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
qui summ col1av
global si=r(sd)
qui summ tsaessay
global se=r(sd)
gsort -male
global v=1

global ll=1
global i=1
while $i<=$nmale & $v<=15001  {

global j=${nmale}+1

while $j<=_N & $v<=15001  {

global l=1

global t1=(tsaoverall[$i]>tsaoverall[$j]+$f*${st})
global t1=$t1*(col1av[$i]>col1av[$j]+$f*${si})
global t1=$t1*(gcsescore[$i]>gcsescore[$j]+$f*${sg})
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
while $m<=$nk {

qui replace Z$m=z$m[1] if _n==$v
global m=$m+1

}
drop z1-z$nk
qui save store, replace


restore
global v=$v+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}

u store, clear

gen a=.


global m=1
while $m<=$nk {
qui summ Z$m
qui replace a=r(max) if _n==$m

global m=$m+1
}
sort a
global nn=int(0.95*$nk)
global k=a[$nn]
preserve
drop if r==.
qui replace r=r+$k*sn
summ r
global upper=r(min)

restore
replace a=10000000000 if a<-5
sort a

global nn=int(0.025*$nk)
global k=a[$nn]
drop if r==.
qui replace r=r+$k*sn
summ r
}
global lower=r(min)
dis "state_indep"
macro lis lower upper
*************************
*************************
*************************

qui {
set more off
clear
clear matrix


global f=0
matrix drop _all
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)



u admit, clear

drop if indep==1


gen c=1
preserve
keep if male==0
logit got_in gcsescore col1av tsaoverall tsaessay
predict phat, p
drop if phat==.
*keep if phat<0.9 & phat>0.1

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
*keep if phat<0.9 & phat>0.1
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


global nn=_N

qui gen nor=invnorm(uniform())

global n=0
global nk=int(($nn-10)/10)
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)
preserve
clear
set obs 15001
gen sn=.
gen zn=.
gen r=.
global m=1
while $m<=$nk {
qui gen Z$m=-1000000000
global m=$m+1
}
qui save store, replace
restore


while $n<=$nk-1 {
global j=1
while $j<=5 {

matrix nkmale[$n+1,$j]=nor[10*$n+$j]

matrix nkfem[$n+1,$j]=nor[10*$n+$j+5]
global j=$j+1

}
global n=$n+1
}

qui drop nor

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
qui summ col1av
global si=r(sd)
qui summ tsaessay
global se=r(sd)
gsort -male
global v=1

global ll=1
global i=1
while $i<=$nmale & $v<=15001  {

global j=${nmale}+1

while $j<=_N & $v<=15001  {

global l=1

global t1=(tsaoverall[$i]>tsaoverall[$j]+$f*${st})
global t1=$t1*(col1av[$i]>col1av[$j]+$f*${si})
global t1=$t1*(gcsescore[$i]>gcsescore[$j]+$f*${sg})
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
while $m<=$nk {

qui replace Z$m=z$m[1] if _n==$v
global m=$m+1

}
drop z1-z$nk
qui save store, replace


restore
global v=$v+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}

u store, clear

gen a=.


global m=1
while $m<=$nk {
qui summ Z$m
qui replace a=r(max) if _n==$m

global m=$m+1
}
sort a
global nn=int(0.95*$nk)
global k=a[$nn]

preserve
drop if r==.
qui replace r=r+$k*sn
summ r
global upper=r(min)

restore
replace a=10000000000 if a<-5
sort a
global nn=int(0.025*$nk)
global k=a[$nn]
drop if r==.
qui replace r=r+$k*sn
summ r
}
global lower=r(min)
dis "male_state-female_state"
macro lis lower upper
**********
*************
qui {
set more off
clear
clear matrix
set mem 100m

global f=0
matrix drop _all
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)



u admit, clear
drop if indep==0

gen c=1
preserve
keep if male==0
logit got_in gcsescore col1av tsaoverall tsaessay
predict phat, p
drop if phat==.
*keep if phat<0.9 & phat>0.1

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
*keep if phat<0.9 & phat>0.1
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


global nn=_N

qui gen nor=invnorm(uniform())

global n=0
global nk=int(($nn-10)/10)
matrix nkmale=J($nk,5,.)
matrix nkfem=J($nk,5,.)
preserve

clear
set obs 15001
gen sn=.
gen zn=.
gen r=.
global m=1
while $m<=$nk {
qui gen Z$m=-1000000000
global m=$m+1
}
qui save store, replace
restore


while $n<=$nk-1 {
global j=1
while $j<=5 {

matrix nkmale[$n+1,$j]=nor[10*$n+$j]

matrix nkfem[$n+1,$j]=nor[10*$n+$j+5]
global j=$j+1

}
global n=$n+1
}

qui drop nor

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
qui summ col1av
global si=r(sd)
qui summ tsaessay
global se=r(sd)
gsort -male
global v=1

global ll=1
global i=1
while $i<=$nmale & $v<=15001  {

global j=${nmale}+1

while $j<=_N & $v<=15001  {

global l=1

global t1=(tsaoverall[$i]>tsaoverall[$j]+$f*${st})
global t1=$t1*(col1av[$i]>col1av[$j]+$f*${si})
global t1=$t1*(gcsescore[$i]>gcsescore[$j]+$f*${sg})
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
while $m<=$nk {

qui replace Z$m=z$m[1] if _n==$v
global m=$m+1

}
drop z1-z$nk
 qui save store, replace


restore
global v=$v+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
macro lis i
}

u store, clear

gen a=.


global m=1
while $m<=$nk {
qui summ Z$m
qui replace a=r(max) if _n==$m

global m=$m+1
}
sort a
global nn=int(0.95*$nk)
global k=a[$nn]
preserve
drop if r==.
qui replace r=r+$k*sn
summ r
global upper=r(min)

restore
replace a=10000000000 if a<-5
sort a

global nn=int(0.025*$nk)
global k=a[$nn]
drop if r==.
qui replace r=r+$k*sn
summ r
}
global lower=r(min)
dis "male_indep-female_indep"
macro lis lower upper
*******************************
*******************************
*******************************
