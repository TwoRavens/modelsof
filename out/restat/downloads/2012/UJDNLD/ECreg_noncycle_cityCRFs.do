clear
set memory 500000
set matsize 8000
program drop _all
mat drop _all
scalar drop _all

program define MATINV
/*
*set set trace on
scalar vdim=colsof(V)
mat Valt=V
local r = 1
local c=1
while `r' <= vdim {
	local c=`r'+1
	while `c' <= vdim {
		mat Valt[`r',`c']=V[`c',`r'] 
		local c=`c'+1
		}
	local r=`r'+1	
	}	
*/

mat Y=V
mat Z=I(colsof(V))
scalar v=1
while v<=50 {

	mat	Yt=(Y+invsym(Z))/2
	mat	Zt=(Z+invsym(Y))/2
	mat	Y=Yt
	mat	Z=Zt
	scalar v=v+1
	}

mat rootV=Y[1..colsof(Y)-1,1..colsof(Y)-1]

local r = 1
while `r' <= colsof(Y)-1 {
	mat rootV[`r',`r']=sqrt(V[`r',`r'])
	local r=`r'+1
	}

end *MATINV


/*****OPTIONS*******/

local lowprice=0   /* 0 if normal, 1 if by adj. price ranking*/




program define RF
display "`city'"
mat Beta_dpp_ro=J(1,plags,0)
mat Beta_dpn_ro=J(1,plags,0)

/* Generates lag price coefficient mats in reverse order*/
*forvalues i = 1/plags {   
local i=1
while `i'<=plags {	
	mat Beta_dpp_ro[1,`i']=Beta_dpp[1,plags+1-`i']
	mat Beta_dpn_ro[1,`i']=Beta_dpn[1,plags+1-`i']
	local i=`i'+1
	}



*mat Bn=-lowertriange(J(lags,lags,1),.)*Beta_dcn+ +hadamard(Beta_pres_1*J(1,lags,1),  + c_1coef*J(1,lags,1))

scalar rflength=50

mat Bn=J(1,rflength,0)
mat bn=J(1,rflength,0)
mat bp=J(1,rflength,0)
mat Bn[1,1]=-Beta_dcn[1,1]
mat bn[1,1]=Bn[1,1]

scalar j=2
while j<=rflength {
	mat dpncoefs=J(1,rflength,0)
	mat dpncoefs[1,max(j-plags,1)]=Beta_dpn_ro[1,1..min(j-1,plags)]
	mat dppcoefs=J(1,rflength,0)
	mat dppcoefs[1,max(j-plags,1)]=Beta_dpp_ro[1,1..min(j-1,plags)]
	if j>=3 mat bn[1,j-1]=cond(Bn[1,j-1]-Bn[1,j-2]<=0,Bn[1,j-1]-Bn[1,j-2],0)
	if j>=3 mat bp[1,j-1]=cond(Bn[1,j-1]-Bn[1,j-2]>0,Bn[1,j-1]-Bn[1,j-2],0)
	mat Bn[1,j]=Bn[1,j-1]-cond(Beta_dcn[1,j]~=.,Beta_dcn[1,j],0)+Beta_presid_1p[1,1]*(Bn[1,j-1]+c_1coef)+ bn*dppcoefs'+bn*dpncoefs'
	*mat Bn[1,j]=Bn[1,j-1]-cond(Beta_dcn[1,j]~=.,Beta_dcn[1,j],0)+bhat[1,"presid_1"]*(Bn[1,j-1]+c_1coef)+ bn*dppcoefs'+bn*dpncoefs'
	scalar j=j+1
	}
mat Bp=J(1,rflength,0)
mat bp=J(1,rflength,0)
mat bn=J(1,rflength,0)
mat Bp[1,1]=Beta_dcp[1,1]
mat bp[1,1]=Bp[1,1]
scalar j=2
while j<=rflength{
	mat dpncoefs=J(1,rflength,0)
	mat dpncoefs[1,max(j-plags,1)]=Beta_dpn_ro[1,1..min(j-1,plags)]
	mat dppcoefs=J(1,rflength,0)
	mat dppcoefs[1,max(j-plags,1)]=Beta_dpp_ro[1,1..min(j-1,plags)]
	if j>=3 mat bn[1,j-1]=cond(Bp[1,j-1]-Bp[1,j-2]<=0,Bp[1,j-1]-Bp[1,j-2],0)
	if j>=3 mat bp[1,j-1]=cond(Bp[1,j-1]-Bp[1,j-2]>0,Bp[1,j-1]-Bp[1,j-2],0)
	mat Bp[1,j]=Bp[1,j-1]+cond(Beta_dcp[1,j]~=.,Beta_dcp[1,j],0)+Beta_presid_1n[1,1]*(Bp[1,j-1]-c_1coef)+ bp*dppcoefs'+bp*dpncoefs'
	*mat Bp[1,j]=Bp[1,j-1]+cond(Beta_dcp[1,j]~=.,Beta_dcp[1,j],0)+bhat[1,"presid_1"]*(Bp[1,j-1]-c_1coef)+ bp*dppcoefs'+bp*dpncoefs'
	scalar j=j+1
	}
	

mat B=((Bp'\1),(Bn'\2))
*mat list B

end  /* program RF*/





program define CAF10
*set trace on
*matrix V=e(V)
*matrix bhat=e(b)
scalar nobs=e(N)

*mat c_1coef=1
mat c_1coef=ccoef


RF
if city==1 mat B_est=(B\(city,city))
if city>1 mat B_est=B_est,(B\(city,city))

end  CAF10

/***********************RUN PROGRAMS************************/

use rack rackstate region p c  date using "OPISCityData.dta"  ,clear


/* DATA TO CONTAIN THE FOLLOWING VARIABLES:
rack 		= CITY WHERE WHOLESALE DISTRIBUTION RACK IS LOCATED
rackstate	= STATE WHERE RACK IS LOCATED	
region		= MSA FOR WHICH AVERAGE RETAIL PRICES ARE OBSERVED
c		= WHOLESALE RACK PRICE OF GASOLINE (THIS IS THE DAILY MINIMUM UNBRANDED GASOLINE PRICE FOR EACH RACK AS QUOTED BY OPIS)
p		= AVERAGE RETAIL PRICE OF GASOLINE FOR THE MSA (THIS IS THE DAILY AVERAGE OF OBSERVED RETAIL PRICES FOR EACH MSA AS REPORTED BY OPIS)
date		= DATE (IN STATA DATE FORMAT)
*/

encode region, gen(regcode)
tsset regcode date
sort regcode date

gen marg= p - c

/* GENERATES A DAY OF WEEK CODE: "0" = SUNDAY ... "6" = SATURDAY */
gen dow=dow(date)

/* WHOLESALE PRICES ARE NOT QUOTED ON SUNDAYS.  WE USE SATURDAY PRICES ARE USED FOR SUNDAYS AS WELL.
THE NEXT THREE COMMANDS FILL IN THE RACK PRICE AND LOCATION INFORMATION FOR SUNDAYS */
replace c=L.c if c==. & dow==0
by regcode: replace rack=rack[_n-1] if rack==""
by regcode: replace rackstate=rackstate[_n-1] if rackstate=="" 


gen dp=D1.p
gen p_1=L.p


/* THESE TWO COMMANDS GENERATE A MEDIAN PRICE CHANGE OVER ALL DAYS USED IN THE SAMPLE FOR EACH CITY */
/* NOTE: date = 16676 CORRESPONDS TO AUGUST 28, 2005.  */
egen mediandpalt=median(dp) if date<=16676, by(region)
egen mediandp=median(mediandpalt), by(region)

compress


/**********************************************************/


sort regcode date

gen dc=D1.c

scalar clags=40
local i=0
while `i'<clags  {
gen dc_`i'=L`i'.dc
gen dc_p`i'=cond(dc_`i'>0,dc_`i',0)
gen dc_n`i'=cond(dc_`i'<=0,dc_`i',0)
local i=`i'+1

}
scalar plags=15
local i=1
while `i'<=plags  {
gen dp_`i'=L`i'.dp
gen dp_p`i'=cond(dp_`i'>0,dp_`i',0)
gen dp_n`i'=cond(dp_`i'<=0,dp_`i',0)
local i=`i'+1

}

****************
drop if mediandp<-.09
****************

areg p c  if mediandp>-.09 & date<=16676 , a(region)

scalar ccoef=_b[c]
predict presid, resid
sort regcode date

gen presid_1=L.presid
gen presid_1p=cond(L1.presid>0,L1.presid,0)
gen presid_1n=cond(L1.presid<=0,L1.presid,0)

xi i.region|presid_1p i.region|presid_1n, noomit
drop _Iregion*

reg dp dc_p* dc_n* dp_p* dp_n* _IregXpres_* _IregXpresa*  if mediandp>-.09 & date<=16676 & e(sample), noc robust


*******************reg dp dc_p* dc_n* dp_p* dp_n* presid_1p presid_1n  if mediandp>-.09  , noc robust


predict e if e(sample), resid
matrix bhatalt=e(b)

scalar v=1
while v<=39 {
	local city=v
	mat bhat=bhatalt[1,1..(colnumb(bhatalt,"dp_n15"))]
	mat bhat=(bhat,bhatalt[1,"_IregXpres_`city'"],bhatalt[1,"_IregXpresa`city'"])
	mat list bhat
	*matrix V=e(V)

	scalar lags=clags
	mat Beta_dcp=bhat[1,1..lags]
	mat Beta_dcn=bhat[1,(lags+1)..2*lags]
	mat Beta_dpp=bhat[1,2*lags+1..2*lags+plags]
	mat Beta_dpn=bhat[1,2*lags+plags+1..2*lags+2*plags]
	mat Beta_presid_1p=bhat[1,"_IregXpres_`city'"]
	mat Beta_presid_1n=bhat[1,"_IregXpresa`city'"]
	scalar city=`city'

	CAF10

	scalar v=v+1
}
*mat list B_est
mat out =B_est'

drop _all
svmat out, names(day)
rename day52 citynum
rename day51 up_down
sort citynum
save "noncycle_city_CRFs.dta", replace




/* FOLLOWING CODE REGENERATES REGION NAMES TO MERGE INTO DATA CREATED ABOVE*/
use rack rackstate region p c  date using "OPISCityData.dta"  ,clear

encode region, gen(regcode)
tsset regcode date
sort regcode date

gen dp=D1.p

/* THESE TWO COMMANDS GENERATE A MEDIAN PRICE CHANGE OVER ALL DAYS USED IN THE SAMPLE FOR EACH CITY */
/* NOTE: date = 16676 CORRESPONDS TO AUGUST 28, 2005.  */
egen mediandpalt=median(dp) if date<=16676, by(region)
egen mediandp=median(mediandpalt), by(region)

****************
drop if mediandp<-.09
****************
encode region, gen(citynum)

collapse citynum ,by(region)
sort citynum

merge citynum using "noncycle_city_CRFs.dta"
sort region
drop _merge
saveold "noncycle_city_CRFs.dta", replace
