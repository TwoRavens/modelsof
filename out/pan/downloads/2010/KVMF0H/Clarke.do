set mem 20m

/*Huth and Allee's Table 9.4*/

use "C:\outgamedata080601c.dta", clear

keep if dvsq1==2

biprobit (dvescbi1=comoppj strval1 odi1 odi2 milrat1 locad1 netdem1 staleb1 netdem2stale1 endriv5j erv5netdem1 ethval1 netdemethval1 mil46unc1 netdemmilunc1 tgirescnetdem tgiresc) (dvescbi2=comoppj strval2 odi2 odi1 milrat2 locad2 netdem2 staleb2 netdem2stale2 endriv5j erv5netdem2 ethval2 netdemethval2 mil46unc2 netdemmilunc2), robust

scalar rho1 = [athrho]_coef[_cons]
scalar rho1 = (exp(2*rho1)-1) / (exp(2*rho1)+1)

gen byte qi11 = 2*(dvescbi1!=0) -1
gen byte qi21 = 2*(dvescbi2!=0) -1 

predict double wi11, eq(dvescbi1)
predict double wi21, eq(dvescbi2)
    
replace wi11 = wi11*qi11
replace wi21 = wi21*qi21

gen double rhoi1 = qi11*qi21*rho1
gen double llr1 = ln(binorm(wi11,wi21,rhoi1))
egen psum1=sum(llr1)
sum psum1

gen case=_n
sort case
save "C:\testdiffs.dta", replace



/*Huth and Allee's Table 9.13*/

use "C:\outgamedata080601a.dta", clear

keep if dvsq1==2

biprobit (dvescbi1=comoppj strval1 odi1 odi2 milrat1 locad1 nviol20lag1 nv20st1yr1 stalea1  nv20milad1) (dvescbi2=comoppj strval2 odi2 odi1 milrat2 locad2  nviol20lag2 nv20st1yr2 stalea2  nv20milad2), robust

scalar rho2 = [athrho]_coef[_cons]
scalar rho2 = (exp(2*rho2)-1) / (exp(2*rho2)+1)

gen byte qi12 = 2*(dvescbi1!=0) -1
gen byte qi22 = 2*(dvescbi2!=0) -1 

predict double wi12, eq(dvescbi1)
predict double wi22, eq(dvescbi2)
    
replace wi12 = wi12*qi12
replace wi22 = wi22*qi22

gen double rhoi2 = qi12*qi22*rho2
gen double llr2 = ln(binorm(wi12,wi22,rhoi2))
egen psum2=sum(llr2)
sum psum2

gen case=_n
sort case

merge case using "C:\testdiffs.dta"


gen corllr1=llr1-(35/(2*_N))*ln(_N)

gen corllr2=llr2-(23/(2*_N))*ln(_N)

signtest corllr1=corllr2




gen  diffll=llr1-llr2
qui sum  diffll
gen  meandfll=r(mean)
gen dfllsq=diffll^2
gen sqmndiff=meandfll^2
qui sum  dfllsq
gen mndfllsq=r(mean)
gen denom = sqrt(mndfllsq-sqmndiff)*sqrt(_N)
gen num = meandfll*_N-((35/2)*ln(_N)-(23/2)*ln(_N))
scalar vuong= num/denom
scalar list vuong
di num
di denom
di norm(vuong)+1-norm(-vuong)
di vuong+1.96*denom
di vuong-1.96*denom

summarize diffll, detail
