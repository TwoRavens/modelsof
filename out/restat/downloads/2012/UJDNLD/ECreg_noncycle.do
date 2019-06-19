clear
set memory 500000
set matsize 8000
program drop _all
mat drop _all
scalar drop _all


/*****OPTIONS*******/

local lowprice=0   /* 0 if normal, 1 if by adj. price ranking*/




program define RF
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
	mat Bn[1,j]=Bn[1,j-1]-cond(Beta_dcn[1,j]~=.,Beta_dcn[1,j],0)+bhat[1,"presid_1p"]*(Bn[1,j-1]+c_1coef)+ bn*dppcoefs'+bn*dpncoefs'
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
	mat Bp[1,j]=Bp[1,j-1]+cond(Beta_dcp[1,j]~=.,Beta_dcp[1,j],0)+bhat[1,"presid_1n"]*(Bp[1,j-1]-c_1coef)+ bp*dppcoefs'+bp*dpncoefs'
	*mat Bp[1,j]=Bp[1,j-1]+cond(Beta_dcp[1,j]~=.,Beta_dcp[1,j],0)+bhat[1,"presid_1"]*(Bp[1,j-1]-c_1coef)+ bp*dppcoefs'+bp*dpncoefs'
	scalar j=j+1
	}
	

mat B=(Bp',Bn')
*mat list B

end  /* program RF*/









program define CRF

scalar nobs=e(N)
mat c_1coef=ccoef
scalar lags=clags



mat Beta_dcp=bhat[1,1..lags]
mat Beta_dcn=bhat[1,(lags+1)..2*lags]
mat Beta_dpp=bhat[1,2*lags+1..2*lags+plags]
mat Beta_dpn=bhat[1,2*lags+plags+1..2*lags+2*plags]
mat Beta_presid_1p=bhat[1,"presid_1p"]
mat Beta_presid_1n=bhat[1,"presid_1n"]



RF
mat B_est=B

scalar simnum=500

mat B_estimates=B
mat Bpboot=J(simnum,rflength,0)
mat Bnboot=J(simnum,rflength,0)

mat Beta=(Beta_dcp,Beta_dcn,Beta_dpp,Beta_dpn,Beta_presid_1p,Beta_presid_1n)

scalar varnum=colsof(Beta)

scalar k=1
while k<=simnum {
	mat randomvec=J(1,varnum,0)
	mat Betadraw=J(1,varnum,0)
	scalar v=1

	while v<=varnum {
		mat randomvec[1,v]=invnormal(uniform())
		scalar v=v+1
		}

	mat cholV=cholesky(V)
	mat Betadraw=(cholesky(V)*randomvec' + Beta')'

	mat Beta_dcp=Betadraw[1,1..lags]
	mat Beta_dcn=Betadraw[1,(lags+1)..2*lags]
	mat Beta_dpp=Betadraw[1,2*lags+1..2*lags+plags]
	mat Beta_dpn=Betadraw[1,2*lags+plags+1..2*lags+2*plags]
	mat Beta_presid_1p=Betadraw[1,colsof(Betadraw)-1]
	mat Beta_presid_1n=Betadraw[1,colsof(Betadraw)]

	RF

	mat Bpboot[k,1]=Bp
	mat Bnboot[k,1]=Bn
	*scalar list k
	scalar k=k+1
	}


drop _all
svmat Bpboot
collapse (p98) Bp*
mkmat Bp*, matrix(Bpub)

drop _all
svmat Bpboot
collapse (p02) Bp*
mkmat Bp*, matrix(Bplb)

drop _all
svmat Bnboot
collapse (p98) Bn*
mkmat Bn*, matrix(Bnub)

drop _all
svmat Bnboot
collapse (p02) Bn*
mkmat Bn*, matrix(Bnlb)

mat Bint=(B_est,Bpub',Bplb',Bnub',Bnlb')
mat list Bint
klasjdf


end  CRF



/***********************RUN PROGRAMS************************/

use rack rackstate region p c date using "OPISCiytData.dta"  ,clear

rename p c
rename retailnet p


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

/*THE FOLLOWING CODE GENERATES 15 LAGGED PRICE CHANGES AND 40 LAGGED COST CHANGES*/

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


/** ESTIMATION OF EQUATION (4).  THIS IS THE FIRST STEP OF THE TWO STEP ESTIMATION OF THE SYSTEM OF EQUATION (3) AND (4)**/
/* ESTIMATION IS RESTRICTED TO NON-CYCLING CITIES DEFINED AS THOSE WITH mediandp>=.1 */
areg p c  if mediandp>-.099 & date<=16676 , a(region)

scalar ccoef=_b[c]

/*THIS GENERATES THE RESIDUAL z FROM EQUATION (4) THAT WILL BE USED TO ESTIMATE EQUATION (3) */
predict presid, resid
sort regcode date

gen presid_1=L.presid
gen presid_1p=cond(L1.presid>0,L1.presid,0)
gen presid_1n=cond(L1.presid<=0,L1.presid,0)


/*BASE SPECIFICATION*/

/*THIS IS THE ESTIMATION OF EQUATION (3)*/
reg dp dc_p* dc_n* dp_p* dp_n* presid_1p presid_1n  if mediandp>-.099 & date<=16676 , noc robust


/* SAVES COEFFICIENT ESTIMATES AND STANDARD ERRORS FOR USE IN CONSTRUCTING CUMULATIVE RESPONSE FUNCTIONS */
predict e if e(sample), resid
matrix bhat=e(b)
matrix V=e(V)

/* RUN "CRF" PROGRAM DEFINED ABOVE TO GENERATE CRFs */
CRF

/*THIS PROGRAM FINISHES BY DISPLAYNG A MATRIX INCLUDING THE ESTIMATED CUMULATIVE RESPONSE FUNCTIONS (CRFs) FOR POSITITVE AND NEGATIVE PRICE CHANGES
IN A NON-CYCLING MARKET.  THE COLUMNS OF THE MATRIX ARE AS FOLLOWS:

COLUMN 1:	CRF FOR A POSITIVE COST CHANGE
COLUMN 2:	CRF FOR A NEGATIVE COST CHANGE
COLUMN 3:	UPPER BOUND OF THE 95% CONFIDENCE INTERVAL FOR THE ESTIMATE OF THE CRF OF A POSITIVE COST CHANGE
COLUMN 4:	LOWERR BOUND OF THE 95% CONFIDENCE INTERVAL FOR THE ESTIMATE OF THE CRF OF A POSITIVE COST CHANGE
COLUMN 5:	UPPER BOUND OF THE 95% CONFIDENCE INTERVAL FOR THE ESTIMATE OF THE CRF OF A NEGATIVE COST CHANGE
COLUMN 6:	LOWERR BOUND OF THE 95% CONFIDENCE INTERVAL FOR THE ESTIMATE OF THE CRF OF A NEGATIVE COST CHANGE

*/


