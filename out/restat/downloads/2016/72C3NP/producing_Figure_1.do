clear
set more off
set ty double

u admit, clear
gen aa=male
replace male=indep
replace indep=aa
drop aa

*replace male=1-male
summ male
global m=round(r(mean)*r(N))
gsort -male
save temp, replace

*********************************************


set matsize 5000
matrix A=J(5000,1,.)
replace gcsescore=tsaessay
gen x1=gcsescore^2
gen x2=tsaoverall^2
gen x3=gcsescore*tsaoverall
qreg col1av indep gcsescore tsaoverall x1 x2 x3 if male==1, quantile(0.50)
qui predict yhatmale, xb
replace yhatmale=. if male==0

qreg col1av indep gcsescore tsaoverall x1 x2 x3 if male==0, quantile(0.50)
qui predict yhatfem, xb
replace yhatfem=. if male==1
*qreg tsaessay indep gcsescore tsaoverall x1 x2 x3, quantile(0.5)

qui summ gcsescore
global sg=r(sd)
qui summ tsaoverall
global st=r(sd)
global f=0.0


*keep if male==0
global k=1

global i=1
while $i<=$m {
global j=$m+1

while $j<=_N {
global l=1
*global t1=($i~=$j)*(male[$i]==1)*(male[$j]==0)*(gcsescore[$i]>gcsescore[$j])*(tsaoverall[$i]>tsaoverall[$j])
global t1=($i~=$j)*(male[$i]==1)*(male[$j]==0)*(gcsescore[$i]>gcsescore[$j]+$f*${sg})
global t1=$t1*(tsaoverall[$i]>tsaoverall[$j]+$f*${st})
*global t1=$t1*(tsapr[$i]>tsapr[$j]+$f*${st})*(tsacr[$i]>tsacr[$j]+$f*${st})

global a=yhatmale[$i]
global b=yhatfem[$j]
*macro lis i j a b

while $t1>0 & $t1~=. & $l<=1 & $k<=5000 {
matrix A[$k,1]=$a-$b
global k=$k+1
global l=$l+1
}
global j=$j+1
}
global i=$i+1
}
svmat A
summ A1, detail
ren A1 indep_state
hist indep_state, bin(50) saving(indep_state, replace)


*******************************************************
