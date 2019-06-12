
clear all
set more off
cd c:\dataverse_files
** one needs to change cd location **
capture log close
log using Election_26AUG2017_Stata, text replace
use USelec_SenateRepre_final,clear

gen proprep_h=oppositions_h/totalseathouse
gen proprep_s=oppositions_s/totalseatsenate
gen s1_demo=propdemo_h-0.5
gen s2_demo=propdemo_s-0.5
gen delta1_demo=s1_demo>=0 
gen delta2_demo=s2_demo>=0 
gen delta_demo=(delta1_demo*delta2_demo)
gen s1_rep=proprep_h-0.5 
gen s2_rep=proprep_s-0.5
gen delta1_rep=s1_rep>=0
gen delta2_rep=s2_rep>=0
gen delta_rep=(delta1_rep*delta2_rep)
gen t=congress


** we use s=proportion of Rep in each house
gen d=delta_rep
gen d1=delta1_rep
gen d2=delta2_rep
gen irr=(delta1_rep==0)*(delta2_rep==0)*(delta_demo==0)
** irr=1 if none of parties dominant
gen sen_rep=1-irr



* ========Choose Dependent Variable
** mf is chosen by Cross-Validation for each neighbor. And it can be obtained with another GAUSS program
****======== Y=LPI ========
quietly sum lpi
gen y_l=(lpi-r(mean))/r(sd)
scalar mf_l_sq=1.4
scalar mf_l_sq1=1.1
scalar mf_l_sq2=1.8
scalar mf_l_ov=1.8
scalar mf_l_ov1=1.5
scalar mf_l_ov2=1.9

****======== Y=MLI ========
quietly sum mli
gen y_m=(mli-r(mean))/r(sd)
scalar mf_m_sq=1.4
scalar mf_m_sq1=2.3
scalar mf_m_sq2=1.4
scalar mf_m_ov=1.6
scalar mf_m_ov1=1.5
scalar mf_m_ov2=1.9

keep if sen_rep==1
** remove the cases that none of parties is the majoritiy


quietly sum s1_rep
scalar sd1=r(sd) 
gen s1=(s1_rep-r(mean))/r(sd)
*normalizing s1
quietly sum s2_rep
scalar sd2=r(sd) 
gen s2=(s2_rep-r(mean))/r(sd)
*normalizing s2
matrix define sd=(sd1\sd2) 
quietly correlate s1 s2 
scalar rho=r(rho) 
scalar n=r(N)
scalar k=2 
** k is a number of running variables
scalar h0=n^(-1/(k+4))
** RoT bandwidth should be SD(S)*h0, and our sd(s1)=sd(s2)=1 by normalizing
scalar neva=5



***********************************************************
********** Square neighbor h RoT **************************
scalar h1=h0
scalar h2=h0
**q is local sample selector 
gen q1=(s1<0)*(s1>=-h1)+(s1>=0)*(s1<=h1) 
gen q2=(s2<0)*(s2>=-h2)+(s2>=0)*(s2<=h2)
gen q_srt=q1*q2
** local sample for srt


** LSE's with linear E(Y0|S) in (3.10)
local x1 "d d1 d2 s1 s2 t"
quietly regress y_l `x1' if q_srt==1, r
estimates store y_l_1_srt
quietly regress y_m `x1' if q_srt==1, r
estimates store y_m_1_srt


** Two min-score approaches 
gen sm=(s1>s2)*s2+(s1<s2)*s1
quietly sum sm
scalar sdm=r(sd)
scalar hm=sdm*h0
gen qm=(sm<0)*(sm>=-hm)+(sm>=0)*(sm<=hm)
local xm "d sm t"        
quietly regress y_l `xm' if qm==1, r
estimates store y_l_m_srt
quietly regress y_m `xm' if qm==1, r
estimates store y_m_m_srt


** One-dimensional localizations 
gen a1=d2*q1
local x11 "d s1 s2 t"
quietly regress y_l `x11' if a1==1, r
estimates store y_l_11_srt
quietly regress y_m `x11' if a1==1, r
estimates store y_m_11_srt

gen a2=d1*q2
local x12 "d s1 s2 t"
quietly regress y_l `x12' if a2==1, r
estimates store y_l_12_srt
quietly regress y_m `x12' if a2==1, r
estimates store y_m_12_srt

*estimates table y_l_1_srt y_l_m_srt y_l_11_srt y_l_12_srt, t keep(d)
*estimates table y_m_1_srt y_m_m_srt y_m_11_srt y_m_12_srt, t keep(d)

drop q1 q2 qm a1 a2



**********************************************************************
********** Square neighbor with single h CV **************************
scalar h1_l=mf_l_sq*h0
scalar h2_l=mf_l_sq*h0
scalar h1_m=mf_m_sq*h0
scalar h2_m=mf_m_sq*h0
gen q1_l=(s1<0)*(s1>=-h1_l)+(s1>=0)*(s1<=h1_l) 
gen q2_l=(s2<0)*(s2>=-h2_l)+(s2>=0)*(s2<=h2_l) 
gen q1_m=(s1<0)*(s1>=-h1_m)+(s1>=0)*(s1<=h1_m) 
gen q2_m=(s2<0)*(s2>=-h2_m)+(s2>=0)*(s2<=h2_m) 
gen q_l_scv=q1_l*q2_l
gen q_m_scv=q1_m*q2_m

** LSE's with linear E(Y0|S) in (3.10)
quietly regress y_l `x1' if q_l_scv==1, r
estimates store y_l_1_scv
quietly regress y_m `x1' if q_m_scv==1, r
estimates store y_m_1_scv

** Two min-score approaches 
scalar hm_l=mf_l_sq*sdm*h0
scalar hm_m=mf_m_sq*sdm*h0
gen qm_l=(sm<0)*(sm>=-hm_l)+(sm>=0)*(sm<=hm_l)
gen qm_m=(sm<0)*(sm>=-hm_m)+(sm>=0)*(sm<=hm_m)
quietly regress y_l `xm' if qm_l==1, r
estimates store y_l_m_scv
quietly regress y_m `xm' if qm_m==1, r
estimates store y_m_m_scv


** One-dimensional localizations 
gen a1_l=d2*q1_l
gen a1_m=d2*q1_m
quietly regress y_l `x11' if a1_l==1, r
estimates store y_l_11_scv
quietly regress y_m `x11' if a1_m==1, r
estimates store y_m_11_scv

gen a2_l=d1*q2_l
gen a2_m=d1*q2_m
quietly regress y_l `x12' if a2_l==1, r
estimates store y_l_12_scv
quietly regress y_m `x12' if a2_m==1, r
estimates store y_m_12_scv


** Boundary-weighting estimator 
gen l=y_l
gen m=y_m
foreach v of varlist l m {
scalar e1lo=h1_`v'
scalar e1hi=((1.75-h1_`v')>h1_`v')*(1.75-h1_`v')+((1.75-h1_`v')<h1_`v')*(h1_`v')
scalar e1inc=(e1hi-e1lo)/neva

scalar e2lo=h2_`v'
scalar e2hi=((1.75-h2_`v')>h2_`v')*(1.75-h2_`v')+((1.75-h2_`v')<h2_l)*(h2_`v')
scalar e2inc=(e2hi-e2lo)/neva


gen eva1=e1lo
gen eva2=e2lo
matrix define blse1c=(0\0\0\0\0)
matrix define blse2c=(0\0\0\0\0)
matrix define den1=(0\0\0\0\0)
matrix define den2=(0\0\0\0\0)

forvalues i=1/5{

  ** cutoff shifts for s1 only; then do ols; no partial effect 
  gen s1c=s1-eva1
  gen q1c=(s1c<0)*(s1c>=-h1_`v')+(s1c>=0)*(s1c<=h1_`v')
  gen a1c=q1c*q2_`v'
  local x1c "d s1c s2 t"
  quietly regress `v' `x1c' if a1c==1, r
  matrix blse1c[`i',1]=_b[d]
  gen ker1=normalden(s1c/h1_`v')*normalden(s2/h2_`v')
  quietly sum ker1
  matrix den1[`i',1]=r(mean)/(h1_`v'*h2_`v')
  quietly replace eva1=eva1+e1inc
 
  gen s2c=s2-eva2
  gen q2c=(s2c<0)*(s2c>=-h2_`v')+(s2c>=0)*(s2c<=h2_`v')
  gen a2c=q2c*q1_`v'
  local x2c "d s2c s1 t"
  quietly regress `v' `x2c' if a2c==1, r
  matrix blse2c[`i',1]=_b[d]
  gen ker2=normalden(s2c/h2_`v')*normalden(s1/h1_`v')
  quietly sum ker2
  matrix den2[`i',1]=r(mean)/(h1_`v'*h2_`v')
  quietly replace eva2=eva2+e2inc 
  drop s1c q1c a1c ker1 s2c q2c a2c ker2 
 
}
drop eva1 eva2  
matrix temp1=den1+den2
scalar sumden=temp1[1,1]+temp1[2,1]+temp1[3,1]+temp1[4,1]+temp1[5,1]
matrix bwei0=(den1'*blse1c+den2'*blse2c)/sumden
scalar bwei_`v'_scv=bwei0[1,1]
}

*estimates table y_l_1_scv y_l_m_scv y_l_11_scv y_l_12_scv, t keep(d)
*estimates table y_m_1_scv y_m_m_scv y_m_11_scv y_m_12_scv, t keep(d)
*disp bwei_l_scv  bwei_m_scv
** CI of bwei is calculated with bootstrap

drop q1_l q2_l q1_m q2_m qm_l qm_m a1_l a1_m a2_l a2_m




**********************************************************************
********** Square neighbor with two h CV **************************
scalar h1_l=mf_l_sq1*h0
scalar h2_l=mf_l_sq2*h0
scalar h1_m=mf_m_sq1*h0
scalar h2_m=mf_m_sq2*h0
gen q1_l=(s1<0)*(s1>=-h1_l)+(s1>=0)*(s1<=h1_l) 
gen q2_l=(s2<0)*(s2>=-h2_l)+(s2>=0)*(s2<=h2_l) 
gen q1_m=(s1<0)*(s1>=-h1_m)+(s1>=0)*(s1<=h1_m) 
gen q2_m=(s2<0)*(s2>=-h2_m)+(s2>=0)*(s2<=h2_m) 
gen q_l_scv2=q1_l*q2_l
gen q_m_scv2=q1_m*q2_m

** LSE's with linear E(Y0|S) in (3.10)
quietly regress y_l `x1' if q_l_scv2==1, r
estimates store y_l_1_scv2
quietly regress y_m `x1' if q_m_scv2==1, r
estimates store y_m_1_scv2

** Two min-score approaches 
scalar mf_l_sm=(mf_l_sq1<mf_l_sq2)*mf_l_sq1+(mf_l_sq1>mf_l_sq2)*mf_l_sq2
scalar mf_m_sm=(mf_m_sq1<mf_m_sq2)*mf_m_sq1+(mf_m_sq1>mf_m_sq2)*mf_m_sq2
scalar hm_l=mf_l_sm*sdm*h0
scalar hm_m=mf_m_sm*sdm*h0
gen qm_l=(sm<0)*(sm>=-hm_l)+(sm>=0)*(sm<=hm_l)
gen qm_m=(sm<0)*(sm>=-hm_m)+(sm>=0)*(sm<=hm_m)
quietly regress y_l `xm' if qm_l==1, r
estimates store y_l_m_scv2
quietly regress y_m `xm' if qm_m==1, r
estimates store y_m_m_scv2


** One-dimensional localizations 
gen a1_l=d2*q1_l
gen a1_m=d2*q1_m
quietly regress y_l `x11' if a1_l==1, r
estimates store y_l_11_scv2
quietly regress y_m `x11' if a1_m==1, r
estimates store y_m_11_scv2

gen a2_l=d1*q2_l
gen a2_m=d1*q2_m
quietly regress y_l `x12' if a2_l==1, r
estimates store y_l_12_scv2
quietly regress y_m `x12' if a2_m==1, r
estimates store y_m_12_scv2


** Boundary-weighting estimator 
foreach v of varlist l m {
scalar e1lo=h1_`v'
scalar e1hi=((1.75-h1_`v')>h1_`v')*(1.75-h1_`v')+((1.75-h1_`v')<h1_`v')*(h1_`v')
scalar e1inc=(e1hi-e1lo)/neva

scalar e2lo=h2_`v'
scalar e2hi=((1.75-h2_`v')>h2_`v')*(1.75-h2_`v')+((1.75-h2_`v')<h2_l)*(h2_`v')
scalar e2inc=(e2hi-e2lo)/neva


gen eva1=e1lo
gen eva2=e2lo
matrix define blse1c=(0\0\0\0\0)
matrix define blse2c=(0\0\0\0\0)
matrix define den1=(0\0\0\0\0)
matrix define den2=(0\0\0\0\0)

forvalues i=1/5{

  ** cutoff shifts for s1 only; then do ols; no partial effect 
  gen s1c=s1-eva1
  gen q1c=(s1c<0)*(s1c>=-h1_`v')+(s1c>=0)*(s1c<=h1_`v')
  gen a1c=q1c*q2_`v'
  local x1c "d s1c s2 t"
  quietly regress `v' `x1c' if a1c==1, r
  matrix blse1c[`i',1]=_b[d]
  gen ker1=normalden(s1c/h1_`v')*normalden(s2/h2_`v')
  quietly sum ker1
  matrix den1[`i',1]=r(mean)/(h1_`v'*h2_`v')
  quietly replace eva1=eva1+e1inc
 
  gen s2c=s2-eva2
  gen q2c=(s2c<0)*(s2c>=-h2_`v')+(s2c>=0)*(s2c<=h2_`v')
  gen a2c=q2c*q1_`v'
  local x2c "d s2c s1 t"
  quietly regress `v' `x2c' if a2c==1, r
  matrix blse2c[`i',1]=_b[d]
  gen ker2=normalden(s2c/h2_`v')*normalden(s1/h1_`v')
  quietly sum ker2
  matrix den2[`i',1]=r(mean)/(h1_`v'*h2_`v')
  quietly replace eva2=eva2+e2inc 
  drop s1c q1c a1c ker1 s2c q2c a2c ker2 
 
}
drop eva1 eva2  
matrix temp1=den1+den2
scalar sumden=temp1[1,1]+temp1[2,1]+temp1[3,1]+temp1[4,1]+temp1[5,1]
matrix bwei0=(den1'*blse1c+den2'*blse2c)/sumden
scalar bwei_`v'_scv2=bwei0[1,1]
}


*estimates table y_l_1_scv2 y_l_m_scv2 y_l_11_scv2 y_l_12_scv2, t keep(d)
*estimates table y_m_1_scv2 y_m_m_scv2 y_m_11_scv2 y_m_12_scv2, t keep(d)
*disp bwei_l_scv2  bwei_m_scv2
** CI of bwei2 is calculated by bootstrap

drop qm_l qm_m a1_l a1_m a2_l a2_m






***********************************************************
********** Oval neighbor h RoT **************************
scalar h1=h0
scalar h2=h0
**q is local sample selector 
gen q_ort=( ((s1/h1)^2)+((s2/h2)^2)-2*rho*(s1/h1)*(s2/h2) )<1
** local sample for oval


** LSE's with linear E(Y0|S) in (3.10)
quietly regress y_l `x1' if q_ort==1, r
estimates store y_l_1_ort
quietly regress y_m `x1' if q_ort==1, r
estimates store y_m_1_ort

*estimates table y_l_1_ort, t keep(d)
*estimates table y_m_1_ort, t keep(d)




********************************************************************
********** Oval neighbor with single h CV **************************
scalar h1_l=mf_l_ov*h0
scalar h2_l=mf_l_ov*h0
scalar h1_m=mf_m_ov*h0
scalar h2_m=mf_m_ov*h0
gen q_l_ocv=( ((s1/h1_l)^2)+((s2/h2_l)^2)-2*rho*(s1/h1_l)*(s2/h2_l) )<=1
gen q_m_ocv=( ((s1/h1_m)^2)+((s2/h2_m)^2)-2*rho*(s1/h1_m)*(s2/h2_m) )<=1


** LSE's with linear E(Y0|S) in (3.10)
quietly regress y_l `x1' if q_l_ocv==1, r
estimates store y_l_1_ocv
quietly regress y_m `x1' if q_m_ocv==1, r
estimates store y_m_1_ocv



** Boundary-weighting estimator 
foreach v of varlist l m {
scalar e1lo=h1_`v'
scalar e1hi=((1.75-h1_`v')>h1_`v')*(1.75-h1_`v')+((1.75-h1_`v')<h1_`v')*(h1_`v')
scalar e1inc=(e1hi-e1lo)/neva

scalar e2lo=h2_`v'
scalar e2hi=((1.75-h2_`v')>h2_`v')*(1.75-h2_`v')+((1.75-h2_`v')<h2_`v')*(h2_`v')
scalar e2inc=(e2hi-e2lo)/neva


gen eva1=e1lo
gen eva2=e2lo
matrix define blse1c=(0\0\0\0\0)
matrix define blse2c=(0\0\0\0\0)
matrix define den1=(0\0\0\0\0)
matrix define den2=(0\0\0\0\0)

forvalues i=1/5{

  ** cutoff shifts for s1 only; then do ols; no partial effect 
  gen s1c=s1-eva1
  quietly sum s1c
  scalar sd1c=r(sd)
  gen q1c=( ((s1c/(sd1c*h1_`v'))^2)+((s2/h2_`v')^2)-2*rho*(s1c/(sd1c*h1_`v'))*(s2/h2_`v') )<=1
  gen a1c=q1c*q2_`v'
  local x1c "d s1c s2 t"
  quietly regress `v' `x1c' if a1c==1, r
  matrix blse1c[`i',1]=_b[d]
  gen ker1=normalden(s1c/h1_`v')*normalden(s2/h2_`v')
  quietly sum ker1
  matrix den1[`i',1]=r(mean)/(h1_`v'*h2_`v')
  quietly replace eva1=eva1+e1inc
 
  gen s2c=s2-eva2
  quietly sum s2c
  scalar sd2c=r(sd) 
  gen q2c=( ((s2c/(sd2c*h2_`v'))^2)+((s1/h1_`v')^2)-2*rho*(s2c/(sd2c*h2_`v'))*(s1/h1_`v') )<=1
  gen a2c=q2c*q1_`v'
  local x2c "d s2c s1 t"
  quietly regress `v' `x2c' if a2c==1, r
  matrix blse2c[`i',1]=_b[d]
  gen ker2=normalden(s2c/h2_`v')*normalden(s1/h1_`v')
  quietly sum ker2
  matrix den2[`i',1]=r(mean)/(h1_`v'*h2_`v')
  quietly replace eva2=eva2+e2inc 
  drop s1c q1c a1c ker1 s2c q2c a2c ker2 
 
}
drop eva1 eva2  
matrix temp1=den1+den2
scalar sumden=temp1[1,1]+temp1[2,1]+temp1[3,1]+temp1[4,1]+temp1[5,1]
matrix bwei0=(den1'*blse1c+den2'*blse2c)/sumden
scalar bwei_`v'_ocv=bwei0[1,1]
}

*estimates table y_l_1_ocv , t keep(d)
*estimates table y_m_1_ocv , t keep(d)
*disp bwei_l_ocv  bwei_m_ocv
** CI of bwei is calculated by bootstrap





**********************************************************************
********** Oval neighbor with two h CV **************************
scalar h1_l=mf_l_ov1*h0
scalar h2_l=mf_l_ov2*h0
scalar h1_m=mf_m_ov1*h0
scalar h2_m=mf_m_ov2*h0
gen q_l_ocv2=( ((s1/h1_l)^2)+((s2/h2_l)^2)-2*rho*(s1/h1_l)*(s2/h2_l) )<=1
gen q_m_ocv2=( ((s1/h1_m)^2)+((s2/h2_m)^2)-2*rho*(s1/h1_m)*(s2/h2_m) )<=1


** LSE's with linear E(Y0|S) in (3.10)
quietly regress y_l `x1' if q_l_ocv2==1, r
estimates store y_l_1_ocv2
quietly regress y_m `x1' if q_m_ocv2==1, r
estimates store y_m_1_ocv2



** Boundary-weighting estimator 
foreach v of varlist l m {
scalar e1lo=h1_`v'
scalar e1hi=((1.75-h1_`v')>h1_`v')*(1.75-h1_`v')+((1.75-h1_`v')<h1_`v')*(h1_`v')
scalar e1inc=(e1hi-e1lo)/neva

scalar e2lo=h2_`v'
scalar e2hi=((1.75-h2_`v')>h2_`v')*(1.75-h2_`v')+((1.75-h2_`v')<h2_l)*(h2_`v')
scalar e2inc=(e2hi-e2lo)/neva


gen eva1=e1lo
gen eva2=e2lo
matrix define blse1c=(0\0\0\0\0)
matrix define blse2c=(0\0\0\0\0)
matrix define den1=(0\0\0\0\0)
matrix define den2=(0\0\0\0\0)

forvalues i=1/5{

  ** cutoff shifts for s1 only; then do ols; no partial effect 
  gen s1c=s1-eva1
  quietly sum s1c
  scalar sd1c=r(sd)
  gen q1c=( ((s1c/(sd1c*h1_`v'))^2)+((s2/h2_`v')^2)-2*rho*(s1c/(sd1c*h1_`v'))*(s2/h2_`v') )<=1
  gen a1c=q1c*q2_`v'
  local x1c "d s1c s2 t"
  quietly regress `v' `x1c' if a1c==1, r
  matrix blse1c[`i',1]=_b[d]
  gen ker1=normalden(s1c/h1_`v')*normalden(s2/h2_`v')
  quietly sum ker1
  matrix den1[`i',1]=r(mean)/(h1_`v'*h2_`v')
  quietly replace eva1=eva1+e1inc
 
  gen s2c=s2-eva2
  quietly sum s2c
  scalar sd2c=r(sd) 
  gen q2c=( ((s2c/(sd2c*h2_`v'))^2)+((s1/h1_`v')^2)-2*rho*(s2c/(sd2c*h2_`v'))*(s1/h1_`v') )<=1
  gen a2c=q2c*q1_`v'
  local x2c "d s2c s1 t"
  quietly regress `v' `x2c' if a2c==1, r
  matrix blse2c[`i',1]=_b[d]
  gen ker2=normalden(s2c/h2_`v')*normalden(s1/h1_`v')
  quietly sum ker2
  matrix den2[`i',1]=r(mean)/(h1_`v'*h2_`v')
  quietly replace eva2=eva2+e2inc 
  drop s1c q1c a1c ker1 s2c q2c a2c ker2 
 
}
drop eva1 eva2  
matrix temp1=den1+den2
scalar sumden=temp1[1,1]+temp1[2,1]+temp1[3,1]+temp1[4,1]+temp1[5,1]
matrix bwei0=(den1'*blse1c+den2'*blse2c)/sumden
scalar bwei_`v'_ocv2=bwei0[1,1]
}


*estimates table y_l_1_ocv2 , t keep(d)
*estimates table y_m_1_ocv2 , t keep(d)
*disp bwei_l_ocv2  bwei_m_ocv2
** CI of bwei2 is calculated by bootstrap





***********************************************************
************************ Table 1 **************************
sum proprep_h proprep_s d lpi mli if sen_rep==1
sum proprep_h proprep_s d lpi mli if s1_rep>=-0.05 & s1_rep<=0.05 & s2_rep>=-0.05 & s2_rep<=0.05 & sen_rep==1
sum proprep_h proprep_s d lpi mli if s1_rep>=-0.1 & s1_rep<=0.1 & s2_rep>=-0.1 & s2_rep<=0.1 & sen_rep==1





***********************************************************
************************  Figure 2 *************************
twoway (line lpi congress,sort lcolor(navy)), xlabel(0(20)120) ylabel(0(50)225) 
graph save lpi, replace
twoway (line mli congress,sort lcolor(red)), xlabel(0(20)120) ylabel(0(5)25)
graph save mli, replace
graph combine lpi.gph mli.gph, xcommon imargin(vsmall) xsize(11) ysize(5) graphregion(margin(small)) 
graph save Figure2,replace




***********************************************************
************************  Figure 3 *************************
twoway (scatter s2_rep s1_rep, msymbol(smcircle_hollow)) (scatter s2_rep s1_rep if q_l_scv==1, msymbol(smcircle)), ytitle(, size(small)) ylabel(-0.5(0.1)0.5, labsize(small)) ymtick(, labsize(small)) xtitle(, size(small)) xlabel(-0.5(0.1)0.5, labsize(small)) xmtick(, labsize(small)) title(Square Neighbor h CV, size(small) margin(small)) legend(size(small) margin(zero) region(margin(tiny)) bmargin(small))
graph save  scv, replace

twoway (scatter s2_rep s1_rep, msymbol(smcircle_hollow)) (scatter s2_rep s1_rep if q_l_scv2==1, msymbol(smcircle)), ytitle(, size(small)) ylabel(-0.5(0.1)0.5, labsize(small)) ymtick(, labsize(small)) xtitle(, size(small)) xlabel(-0.5(0.1)0.5, labsize(small)) xmtick(, labsize(small)) title(Square Neighbor h1 h2 CV, size(small) margin(small)) legend(size(small) margin(zero) region(margin(tiny)) bmargin(small))
graph save  scv2, replace

twoway (scatter s2_rep s1_rep, msymbol(smcircle_hollow)) (scatter s2_rep s1_rep if q_l_ocv==1, msymbol(smcircle)), ytitle(, size(small)) ylabel(-0.5(0.1)0.5, labsize(small)) ymtick(, labsize(small)) xtitle(, size(small)) xlabel(-0.5(0.1)0.5, labsize(small)) xmtick(, labsize(small))  title(Oval Neighbor h CV, size(small) margin(small)) legend(size(small) margin(zero) region(margin(tiny)) bmargin(small))
graph save  ocv, replace

twoway (scatter s2_rep s1_rep, msymbol(smcircle_hollow)) (scatter s2_rep s1_rep if q_l_ocv2==1, msymbol(smcircle)), ytitle(, size(small)) ylabel(-0.5(0.1)0.5, labsize(small)) ymtick(, labsize(small)) xtitle(, size(small))  xlabel(-0.5(0.1)0.5, labsize(small)) xmtick(, labsize(small))  title(Oval Neighbor h1 h2 CV, size(small) margin(small)) legend(size(small) margin(zero) region(margin(tiny)) bmargin(small))
graph save  ocv2, replace

graph combine scv.gph  scv2.gph  ocv.gph  ocv2.gph, ycommon xcommon imargin(vsmall) xsize(9) ysize(8) graphregion(margin(small))
graph save Figure3,replace





************************ Table 2 Y=LPI ****************************
************************ Results of Beta_d ************************
********** OLS results **********************************
estimates table y_l_1_srt y_l_1_scv y_l_1_scv2 y_l_1_ort y_l_1_ocv y_l_1_ocv2 , t keep(d)
********** Bound-Wei. results (CI is calculated by bootstrap)
disp bwei_l_scv bwei_l_scv2 bwei_l_ocv bwei_l_ocv2
********** Min.SRD results ******************************
estimates table  y_l_m_srt y_l_m_scv y_l_m_scv2, t keep(d)
********** RD1.SRD results ******************************
estimates table  y_l_11_srt y_l_11_scv y_l_11_scv2, t keep(d)
********** RD2.SRD results ******************************
estimates table  y_l_12_srt y_l_12_scv y_l_12_scv2, t keep(d)


************************ Results of Beta_1/2 **********************
********** Square neighbor h RoT **********************************
estimates table y_l_1_srt y_l_1_scv y_l_1_scv2 y_l_1_ort y_l_1_ocv y_l_1_ocv2, t keep(d1 d2)





************************ Table 3 Y=MLI ****************************
************************ Results of Beta_d ************************
********** OLS results **********************************
estimates table y_m_1_srt y_m_1_scv y_m_1_scv2 y_m_1_ort y_m_1_ocv y_m_1_ocv2 , t keep(d)
********** Bound-Wei. results (CI is calculated by bootstrap)
disp bwei_m_scv bwei_m_scv2 bwei_m_ocv bwei_m_ocv2
********** Min.SRD results ******************************
estimates table  y_m_m_srt y_m_m_scv y_m_m_scv2, t keep(d)
********** RD1.SRD results ******************************
estimates table  y_m_11_srt y_m_11_scv y_m_11_scv2, t keep(d)
********** RD2.SRD results ******************************
estimates table  y_m_12_srt y_m_12_scv y_m_12_scv2, t keep(d)


************************ Results of Beta_1/2 **********************
********** Square neighbor h RoT **********************************
estimates table y_m_1_srt y_m_1_scv y_m_1_scv2 y_m_1_ort y_m_1_ocv y_m_1_ocv2, t keep(d1 d2)



log off
