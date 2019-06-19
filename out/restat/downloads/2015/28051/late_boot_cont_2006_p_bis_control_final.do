
clear all
set more off

cd "set here the path folder where the data are stored and output should be saved"

local maxiter=400
set obs `maxiter'

gen numM=.
gen denM=.
gen lateM=.
gen atM=.
gen ntM=.


save bst_results_cont_2006_p_bis_control.dta, replace

/*BOOTSTRAP - LOOP*/
**We compute the empirical distribution of the estimators whose standard deviation gives us the SEs for each estimate

local j1 = 1

while (`j1'<=`maxiter'){
	use cont_w1w2_2006_p, replace
	bsample
  
**Katz Index
**This is combining PH049 and PH=10 (continence) in adlg_k2
gen katz2=6 if adlg_k2==0
replace katz2=5 if adlg_k2==1
replace katz2=4 if adlg_k2==2
replace katz2=3 if adlg_k2==3
replace katz2=2 if adlg_k2==4
replace katz2=1 if adlg_k2==5
replace katz2=0 if adlg_k2==6
gen katz2_6=(katz2==6)
gen katz2_4=(katz2==4)
gen katz2_2=(katz2<=2)
gen katz2_0=(katz2==0)


**This is the definition (katz4_low, katz4_med) used in the table 6 of the paper
gen katz4_6=(katz2==6)
gen katz4_low=(katz2<=2)
gen katz4_med=(katz2==3 | katz2==4 | katz2==5 )


**Different definitions of good parental health
**Perfect health based on the first 4 instruments
gen inst000k_2=(ivphealth==0 & katz4_low==0 & katz4_med==0 & mentald==0) 
**Perfect health based on the 5 instruments
gen inst000k_3=(ivphealth==0 & katz2_6==1 & mentald==0 & mobilitygd==0) 

**Different combinations of parental disability conditions
gen katz_low=(katz4_low==1 & katz4_med==0 & mentald==0)
gen katz_med=(ivphealth==0 & katz4_low==0 & katz4_med==1 & mentald==0)
gen instpoork4=(ivphealth==1 &  katz4_low==0 & mentald==0)
gen instotherk4=(ivphealth==0 & katz4_low==0 & katz4_med==0 & mentald==0 & mobilitygd==1) 


**RESULTS: From the following regressions, we obtain results in Table 6
**We need to activate the proper regression and predictions each time to generate the corresponding result in each row of the table

**northern countries
**This is to generate result in Panel A row 1
*biprobit (worker1=ivphealth age1 educ sisters) (daily=ivphealth age1 educ sisters) if group==2, cluster(id1) 
**This is to generate result in Panel A row 2
*biprobit (worker1=inst000k_2 age1 educ sisters) (daily=inst000k_2 age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel A row 3
*biprobit (worker1=inst000k_3 age1 educ sisters) (daily=inst000k_3 age1 educ sisters) if group==2, cluster(id1)


**This is to generate result in Panel B row 1
*biprobit (worker1=inst000k_3 katz_low age1 educ sisters) (daily=inst000k_3 katz_low age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 2
*biprobit (worker1=inst000k_3 katz_med age1 educ sisters) (daily=inst000k_3 katz_med age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 3
*biprobit (worker1=inst000k_3 instpoork4 age1 educ sisters) (daily=inst000k_3 instpoork4 age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 4
*biprobit (worker1=inst000k_3 mentald age1 educ sisters) (daily=inst000k_3 mentald age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 5
*biprobit (worker1=inst000k_3 instotherk4 age1 educ sisters) (daily=inst000k_3 instotherk4 age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 6
biprobit (worker1=inst000k_3 age1 educ sisters) (daily=inst000k_3 age1 educ sisters) if group==2, cluster(id1)

predict xbhat, xb1
predict xghat, xb2
matrix coef=e(b)
svmat coef, name(b)

replace b6=b6[_n-1] in 2/l
replace b1=b1[_n-1] in 2/l
replace b2=b2[_n-1] in 2/l
replace b7=b7[_n-1] in 2/l
replace b8=b8[_n-1] in 2/l

**Predictions for the different combinations of instruments

**This is to generate result in Panel A row 1
*gen x0b=xbhat-(b1*ivphealth) if group==2
*gen x1b=x0b+b1 if group==2
*gen x0g=xghat-(b6*ivphealth) if group==2
*gen x1g=x0g+b6 if group==2

**This is to generate result in Panel A row 2
*gen x0b=xbhat-(b1*inst000k_2)+b1 if group==2 
*gen x1b=xbhat-(b1*inst000k_2) if group==2
*gen x0g=xghat-(b6*inst000k_2)+b6 if group==2
*gen x1g=xghat-(b6*inst000k_2) if group==2

**This is to generate result in Panel A row 3 and in Panel B row 6
gen x0b=xbhat-(b1*inst000k_3)+b1 if group==2
gen x1b=xbhat-(b1*inst000k_3) if group==2
gen x0g=xghat-(b6*inst000k_3)+b6 if group==2
gen x1g=xghat-(b6*inst000k_3) if group==2

**This is to generate result in Panel B row 1
*gen x0b=xbhat-(b1*inst000k_3)-(b2*katz_low)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*katz_low)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*katz_low)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*katz_low)+b8 if group==2

**This is to generate result in Panel B row 2
*gen x0b=xbhat-(b1*inst000k_3)-(b2*katz_med)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*katz_med)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*katz_med)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*katz_med)+b8 if group==2

**This is to generate result in Panel B row 3
*gen x0b=xbhat-(b1*inst000k_3)-(b2*instpoork4)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*instpoork4)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*instpoork4)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*instpoork4)+b8 if group==2

**This is to generate result in Panel B row 4
*gen x0b=xbhat-(b1*inst000k_3)-(b2*mentald)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*mentald)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*mentald)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*mentald)+b8 if group==2

**This is to generate result in Panel B row 5
*gen x0b=xbhat-(b1*inst000k_3)-(b2*instotherk4)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*instotherk4)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*instotherk4)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*instotherk4)+b8 if group==2

gen df0b=normal(x0b) if group==2
gen df1b=normal(x1b) if group==2
gen df0g=normal(x0g) if group==2
gen df1g=normal(x1g) if group==2
gen numi=df1b-df0b if group==2
gen denomi=df1g-df0g if group==2
gen ati=df0g if group==2
gen nti=1-df1g if group==2



egen numiM=mean(numi)
egen deniM=mean(denomi)
gen lateiM=numiM/deniM
egen atiM=mean(ati)
egen ntiM=mean(nti)


local M1=numiM[1]
local M2=deniM[1]
local M3=lateiM[1]
local M4=atiM[1]
local M5=ntiM[1]


use bst_results_cont_2006_p_bis_control.dta, clear

replace numM=`M1' if _n==`j1' 
replace denM=`M2' if _n==`j1' 
replace lateM=`M3' if _n==`j1' 
replace atM=`M4' if _n==`j1' 
replace ntM=`M5' if _n==`j1' 


save bst_results_cont_2006_p_bis_control.dta, replace
local j1=`j1'+1
disp "Number of Iterations"
disp `j1'
}
sum

sum numM
local numMst=r(sd)
sum denM
local denMst=r(sd)
sum lateM
local lateMst=r(sd)

sum lateM
_pctile lateM, p(0.5, 2.5, 5, 95, 97.5, 99.5)
local plate1=r(r1)
local plate2=r(r2)
local plate3=r(r3)
local plate4=r(r4)
local plate5=r(r5)
local plate6=r(r6)

sum atM
local atMst=r(sd)
sum ntM
local ntMst=r(sd)


use cont_w1w2_2006_p, replace
**We compute the estimators from the real sample

   **Katz Index
**This is combining PH049 and PH=10 (continence) in adlg_k2
gen katz2=6 if adlg_k2==0
replace katz2=5 if adlg_k2==1
replace katz2=4 if adlg_k2==2
replace katz2=3 if adlg_k2==3
replace katz2=2 if adlg_k2==4
replace katz2=1 if adlg_k2==5
replace katz2=0 if adlg_k2==6
gen katz2_6=(katz2==6)
gen katz2_4=(katz2==4)
gen katz2_2=(katz2<=2)
gen katz2_0=(katz2==0)


**This is the definition (katz4_low, katz4_med) used in the table 6 of the paper
gen katz4_6=(katz2==6)
gen katz4_low=(katz2<=2)
gen katz4_med=(katz2==3 | katz2==4 | katz2==5 )


**Different definitions of good parental health
**Perfect health based on the first 4 instruments
gen inst000k_2=(ivphealth==0 & katz4_low==0 & katz4_med==0 & mentald==0) 
**Perfect health based on the 5 instruments
gen inst000k_3=(ivphealth==0 & katz2_6==1 & mentald==0 & mobilitygd==0) 

**Different combinations of parental disability conditions
gen katz_low=(katz4_low==1 & katz4_med==0 & mentald==0)
gen katz_med=(ivphealth==0 & katz4_low==0 & katz4_med==1 & mentald==0)
gen instpoork4=(ivphealth==1 &  katz4_low==0 & mentald==0)
gen instotherk4=(ivphealth==0 & katz4_low==0 & katz4_med==0 & mentald==0 & mobilitygd==1) 

**RESULTS: From the following regressions, we obtain results in Table 6
**We need to activate the proper regression and predictions each time to generate the corresponding result in each row of the table

**This is to generate result in Panel A row 1
*biprobit (worker1=ivphealth age1 educ sisters) (daily=ivphealth age1 educ sisters) if group==2, cluster(id1) 
**This is to generate result in Panel A row 2
*biprobit (worker1=inst000k_2 age1 educ sisters) (daily=inst000k_2 age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel A row 3
*biprobit (worker1=inst000k_3 age1 educ sisters) (daily=inst000k_3 age1 educ sisters) if group==2, cluster(id1)


**This is to generate result in Panel B row 1
*biprobit (worker1=inst000k_3 katz_low age1 educ sisters) (daily=inst000k_3 katz_low age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 2
*biprobit (worker1=inst000k_3 katz_med age1 educ sisters) (daily=inst000k_3 katz_med age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 3
*biprobit (worker1=inst000k_3 instpoork4 age1 educ sisters) (daily=inst000k_3 instpoork4 age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 4
*biprobit (worker1=inst000k_3 mentald age1 educ sisters) (daily=inst000k_3 mentald age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 5
*biprobit (worker1=inst000k_3 instotherk4 age1 educ sisters) (daily=inst000k_3 instotherk4 age1 educ sisters) if group==2, cluster(id1)
**This is to generate result in Panel B row 6
biprobit (worker1=inst000k_3 age1 educ sisters) (daily=inst000k_3 age1 educ sisters) if group==2, cluster(id1) 

  
   
predict xbhat, xb1
predict xghat, xb2
matrix coef=e(b)
svmat coef, name(b)

replace b6=b6[_n-1] in 2/l
replace b1=b1[_n-1] in 2/l
replace b2=b2[_n-1] in 2/l
replace b7=b7[_n-1] in 2/l
replace b8=b8[_n-1] in 2/l


**Predictions for the different combinations of instruments

**This is to generate result in Panel A row 1
*gen x0b=xbhat-(b1*ivphealth) if group==2
*gen x1b=x0b+b1 if group==2
*gen x0g=xghat-(b6*ivphealth) if group==2
*gen x1g=x0g+b6 if group==2

**This is to generate result in Panel A row 2
*gen x0b=xbhat-(b1*inst000k_2)+b1 if group==2 
*gen x1b=xbhat-(b1*inst000k_2) if group==2
*gen x0g=xghat-(b6*inst000k_2)+b6 if group==2
*gen x1g=xghat-(b6*inst000k_2) if group==2

**This is to generate result in Panel A row 3 and in Panel B row 6
gen x0b=xbhat-(b1*inst000k_3)+b1 if group==2 
gen x1b=xbhat-(b1*inst000k_3) if group==2
gen x0g=xghat-(b6*inst000k_3)+b6 if group==2
gen x1g=xghat-(b6*inst000k_3) if group==2

**This is to generate result in Panel B row 1
*gen x0b=xbhat-(b1*inst000k_3)-(b2*katz_low)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*katz_low)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*katz_low)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*katz_low)+b8 if group==2

**This is to generate result in Panel B row 2
*gen x0b=xbhat-(b1*inst000k_3)-(b2*katz_med)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*katz_med)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*katz_med)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*katz_med)+b8 if group==2

**This is to generate result in Panel B row 3
*gen x0b=xbhat-(b1*inst000k_3)-(b2*instpoork4)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*instpoork4)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*instpoork4)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*instpoork4)+b8 if group==2

**This is to generate result in Panel B row 4
*gen x0b=xbhat-(b1*inst000k_3)-(b2*mentald)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*mentald)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*mentald)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*mentald)+b8 if group==2

**This is to generate result in Panel B row 5
*gen x0b=xbhat-(b1*inst000k_3)-(b2*instotherk4)+b1 if group==2
*gen x1b=xbhat-(b1*inst000k_3)-(b2*instotherk4)+b2 if group==2
*gen x0g=xghat-(b7*inst000k_3)-(b8*instotherk4)+b7 if group==2
*gen x1g=xghat-(b7*inst000k_3)-(b8*instotherk4)+b8 if group==2


gen df0b=normal(x0b) if group==2
gen df1b=normal(x1b) if group==2
gen df0g=normal(x0g) if group==2
gen df1g=normal(x1g) if group==2
gen numi=df1b-df0b if group==2
gen denomi=df1g-df0g if group==2
gen ati=df0g if group==2
gen nti=1-df1g if group==2


egen numiM=mean(numi)
egen deniM=mean(denomi)
gen lateiM=numiM/deniM
egen atiM=mean(ati)
egen ntiM=mean(nti)



sum  numiM
sum  deniM
sum lateiM
sum atiM
sum ntiM

gen numMt=numiM/`numMst'
gen numMpv=2*(1-normal(abs(numMt)))

gen denMt=deniM/`denMst'
gen denMpv=2*(1-normal(abs(denMt)))

gen lateMt=lateiM/`lateMst'
gen lateMpv=2*(1-normal(abs(lateMt)))

gen atMt=atiM/`atMst'
gen atMpv=2*(1-normal(abs(atMt)))

gen ntMt=ntiM/`ntMst'
gen ntMpv=2*(1-normal(abs(ntMt)))

gen sdnum=`numMst'
gen sdden=`denMst'
gen sdlate=`lateMst'
egen plate05=mean(`plate1')
egen plate25=mean(`plate2')
egen plate5=mean(`plate3')
egen plate95=mean(`plate4')
egen plate975=mean(`plate5')
egen plate995=mean(`plate6')

gen sdat=`atMst'
gen sdnt=`ntMst'


**RESULTS
**For the SEs of the numerator and the denominator you need to look at sd4 and sd5 respectively
**For the 95 percent CI of the estimator of LATE you need to look into plate25 and plate975
sum numiM numMt sdnum numMpv
sum deniM denMt sdden denMpv
sum atiM atMt sdat atMpv
sum ntiM ntMt sdnt ntMpv
sum lateiM lateMt sdlate lateMpv plate05 plate25 plate5 plate95 plate975 plate995







