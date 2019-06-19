/************* Generate additional data *******************/
clear all
set mem 100m
set more off
global datain  "C:\JECDynamics\Data\"
global dataout "C:\JECDynamics\Results\"
global datatmp "C:\JECDynamics\Temp\"
global fig  "C:\JECDynamics\Figures\"

use "${datain}Datageneration1.dta", clear
keep t GPN GP1N GPC GR GRLR GRLC GRAll PR
drop if GR==.
sort t
drop t
gen t=_n
sort t
save "${datatmp}tmp1.dta", replace

* Load firm-level information dataset
use "${datain}firmdata.dta", clear
drop gr /* Was GR in our notation, and it already existed in the dataset*/
sort t
merge t using "${datatmp}tmp1.dta"
drop _merge
sort t

* Variables
rename lks L /* Lakes dummy */
gen gr=log(GR)
gen LC=(GRLC!=.&GRLC!=0) /* Dummy =1 for lakes and canals open */
gen LR=(GRLR!=.&GRLR!=0) /* Dummy =1 for lakes and railroads open */
gen grLC=log(GRLC) 
replace grLC=0 if grLC==.&year<=1883 /* GRLC were all below 1, so grLC=0 approximates GRLC=infinity. GRLC was available only sporadically 
                                        after 1883 so we have decided not to report it */
gen grLR=log(GRLR)
replace grLR=0 if grLR==. /* GRLR were all below 1, so grLR=0 approximates GRLR=infinity */

* Month Dummies
gen m1 =(t>=1&t<=4)|(t>=53&t<=56)|(t>=105&t<=108)|/*
*/(t>=157&t<=160)|(t>=209&t<=212)|(t>=261&t<=264)|(t>=313&t<=316)
gen m2 =(t>=5&t<=8)|(t>=57&t<=60)|(t>=109&t<=112)|/*
*/(t>=161&t<=164)|(t>=213&t<=216)|(t>=265&t<=268)|(t>=317&t<=320)
gen m3 =(t>=9&t<=12)|(t>=61&t<=64)|(t>=113&t<=116)|/*
*/(t>=165&t<=168)|(t>=217&t<=220)|(t>=269&t<=272)|(t>=321&t<=324)
gen m4 =(t>=13&t<=16)|(t>=65&t<=68)|(t>=117&t<=120)|/*
*/(t>=169&t<=172)|(t>=221&t<=224)|(t>=273&t<=276)|(t>=325&t<=328)
gen m5 =(t>=17&t<=20)|(t>=69&t<=72)|(t>=121&t<=124)|/*
*/(t>=173&t<=176)|(t>=225&t<=228)|(t>=277&t<=280)
gen m6 =(t>=21&t<=24)|(t>=73&t<=76)|(t>=125&t<=128)|/*
*/(t>=177&t<=180)|(t>=229&t<=232)|(t>=281&t<=284)
gen m7 =(t>=25&t<=28)|(t>=77&t<=80)|(t>=129&t<=132)|/*
*/(t>=181&t<=184)|(t>=233&t<=236)|(t>=285&t<=288)
gen m8 =(t>=29&t<=32)|(t>=81&t<=84)|(t>=133&t<=136)|/*
*/(t>=185&t<=188)|(t>=237&t<=240)|(t>=289&t<=292)
gen m9 =(t>=33&t<=36)|(t>=85&t<=88)|(t>=137&t<=140)|/*
*/(t>=189&t<=192)|(t>=241&t<=244)|(t>=293&t<=296)
gen m10=(t>=37&t<=40)|(t>=89&t<=92)|(t>=141&t<=144)|/*
*/(t>=193&t<=196)|(t>=245&t<=248)|(t>=297&t<=300)
gen m11=(t>=41&t<=44)|(t>=93&t<=96)|(t>=145&t<=148)|/*
*/(t>=197&t<=200)|(t>=249&t<=252)|(t>=301&t<=304)
gen m12=(t>=45&t<=48)|(t>=97&t<=100)|(t>=149&t<=152)|/*
*/(t>=201&t<=204)|(t>=253&t<=256)|(t>=305&t<=308)
gen mth=1 if m1==1 
replace mth=2 if m2==1
replace mth=3 if m3==1
replace mth=4 if m4==1
replace mth=5 if m5==1
replace mth=6 if m6==1
replace mth=7 if m7==1
replace mth=8 if m8==1
replace mth=9 if m9==1
replace mth=10 if m10==1
replace mth=11 if m11==1
replace mth=12 if m12==1

* Structural dummies
gen S1 = t>=28 & t<=166
gen S2 = t>=167 & t<=181
gen S3 = t>=182 & t<=323
gen S4 = t>=324 & t<=328

* Replace year as to be sure years are of 52 weeks each (this follows the same logic than months in Porter)
replace year=1880 if t>=1&t<=52
replace year=1881 if t>=53&t<=104
replace year=1882 if t>=105&t<=156
replace year=1883 if t>=157&t<=208
replace year=1884 if t>=209&t<=260
replace year=1885 if t>=261&t<=312
replace year=1886 if t>=313&t<=328

* Year dummies
tab year, gen(yr)
sort year mth t
/*
*Generating the order of weeks in a month
egen tsh1=max(t), by(year mth)
gen tsh2=tsh1[_n]-tsh1[_n-1]
gen wkm=1 if tsh2!=0
replace wkm=2 if wkm[_n]==.&wkm[_n-1]==1
replace wkm=3 if wkm[_n]==.&wkm[_n-1]==2
replace wkm=4 if wkm[_n]==.&wkm[_n-1]==3
tab wkm, gen(wkm)
*/
* Generate yearly cumulative number weeks Lakes are open, NWO, and yearly de-cumulative number of weeks to the opening of the Lakes, NWC.
egen minwyr=min(t), by(year)
gen intwyr=minwyr+26
egen maxwyr=max(t), by(year)
gen trash0=t if year==1880&L==0&(t>=minwyr&t<intwyr)
egen tmp0=group(trash0)
egen tmp00=max(tmp0)
replace tmp0=tmp00-tmp0
gen trash1=t if (year==1880&L==0&(t>=intwyr&t<=maxwyr))|(year==1881&L==0&(t>=minwyr&t<intwyr))
egen tmp1=group(trash1)
egen tmp11=max(tmp1)
replace tmp1=tmp11-tmp1
gen trash2=t if (year==1881&L==0&(t>=intwyr&t<=maxwyr))|(year==1882&L==0&(t>=minwyr&t<intwyr))
egen tmp2=group(trash2)
egen tmp22=max(tmp2)
replace tmp2=tmp22-tmp2
gen trash3=t if (year==1882&L==0&(t>=intwyr&t<=maxwyr))|(year==1883&L==0&(t>=minwyr&t<intwyr))
egen tmp3=group(trash3)
egen tmp33=max(tmp3)
replace tmp3=tmp33-tmp3
gen trash4=t if (year==1883&L==0&(t>=intwyr&t<=maxwyr))|(year==1884&L==0&(t>=minwyr&t<intwyr))
egen tmp4=group(trash4)
egen tmp44=max(tmp4)
replace tmp4=tmp44-tmp4
gen trash5=t if (year==1884&L==0&(t>=intwyr&t<=maxwyr))|(year==1885&L==0&(t>=minwyr&t<intwyr))
egen tmp5=group(trash5)
egen tmp55=max(tmp5)
replace tmp5=tmp55-tmp5
gen trash6=t if (year==1885&L==0&(t>=intwyr&t<=maxwyr))|(year==1886&L==0&(t>=minwyr&t<intwyr))
egen tmp6=group(trash6)
egen tmp66=max(tmp6)
replace tmp6=tmp66-tmp6
egen NWC=rowtotal(tmp0 tmp1 tmp2 tmp3 tmp4 tmp5 tmp6)
drop trash* tmp*
gen trash0=t if year==1880&L==1
egen tmp0=group(trash0)
gen trash1=t if year==1881&L==1
egen tmp1=group(trash1)
gen trash2=t if year==1882&L==1
egen tmp2=group(trash2)
gen trash3=t if year==1883&L==1
egen tmp3=group(trash3)
gen trash4=t if year==1884&L==1
egen tmp4=group(trash4)
gen trash5=t if year==1885&L==1
egen tmp5=group(trash5)
gen trash6=t if year==1886&L==1
egen tmp6=group(trash6)
egen NWO=rowtotal(tmp0 tmp1 tmp2 tmp3 tmp4 tmp5 tmp6)
drop trash* tmp* 

* Ellison Data 
egen Q1=rowtotal(mcg lsg npg) /* Firm 1 includes MC, LS, and NP) */
egen Q2=rowtotal(fwg phg) /* Firm 2 includes FW, and PH) */
gen Q3=bog
gen Q4=gtg
gen Q5=cag
egen Q=rowtotal(Q1 Q2 Q3 Q4 Q5)
gen q=log(Q)
* Number of firms
gen N=(Q1>0)+(Q2>0)+(Q3>0)+(Q4>0)+(Q5>0)
* Market shares allocation
egen a1=rowtotal(mcal lsal npal) 
egen a2=rowtotal(fwal phal)
gen a3=boal
gen a4=gtal
gen a5=caal
egen A=rowtotal(a1 a2 a3 a4 a5)
* Actual Market Shares
gen s1=Q1/Q
gen s2=Q2/Q
gen s3=Q3/Q
gen s4=Q4/Q
gen s5=Q5/Q
egen S=rowtotal(s1 s2 s3 s4 s5)
* Absolute Deviations 
gen d1=abs(a1-s1)
gen d2=abs(a2-s2)
gen d3=abs(a3-s3)
gen d4=abs(a4-s4)
gen d5=abs(a5-s5)
* Ellison BIGSHARE1 variable
gen q1=log(Q1)
gen q2=log(Q2)
gen q3=log(Q3)
gen q4=log(Q4)
gen q5=log(Q5)
egen qi=rowmean(q1 q2 q3 q4 q5)
gen s_1t=q1-qi
gen s_2t=q2-qi
gen s_3t=q3-qi
gen s_4t=q4-qi
gen s_5t=q5-qi
local i=1
while `i'<13{
		gen tmp_`i'=s_1t[_n-`i']
		local i=`i'+1
	}
egen sbar_1t=rowmean(tmp_1-tmp_12)
egen sds_1=sd(s_1t)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=s_2t[_n-`i']
		local i=`i'+1
	}
egen sbar_2t=rowmean(tmp_1-tmp_12)
egen sds_2=sd(s_2t)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=s_3t[_n-`i']
		local i=`i'+1
	}
egen sbar_3t=rowmean(tmp_1-tmp_12)
egen sds_3=sd(s_3t)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=s_4t[_n-`i']
		local i=`i'+1
	}
egen sbar_4t=rowmean(tmp_1-tmp_12)
egen sds_4=sd(s_4t)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=s_5t[_n-`i']
		local i=`i'+1
	}
egen sbar_5t=rowmean(tmp_1-tmp_12)
egen sds_5=sd(s_5t)
drop tmp_*
local i=1
while `i'<6{
		gen tmp_`i'=(s_`i't-sbar_`i't)/sds_`i'
		local i=`i'+1
	}
egen Big1=rowmax(tmp_1-tmp_5)
*Ellison SMALLSHARE1
replace tmp_1=. if tmp_1>=0
replace tmp_2=. if tmp_2>=0
replace tmp_3=. if tmp_3>=0
replace tmp_4=. if tmp_4>=0
replace tmp_5=. if tmp_5>=0
egen Small1=rowmin(tmp_1-tmp_5)
replace Small1=-Small1
replace Small1=0 if Small1==. in 2/328
drop tmp_* sbar_* q1-q5
*Ellison BIGSHAREQ
local i=1
while `i'<13{
		gen tmp_`i'=a1[_n-`i']
		local i=`i'+1
	}
egen sbar_1t=rowmean(tmp_1-tmp_12)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=a2[_n-`i']
		local i=`i'+1
	}
egen sbar_2t=rowmean(tmp_1-tmp_12)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=a3[_n-`i']
		local i=`i'+1
	}
egen sbar_3t=rowmean(tmp_1-tmp_12)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=a4[_n-`i']
		local i=`i'+1
	}
egen sbar_4t=rowmean(tmp_1-tmp_12)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=a5[_n-`i']
		local i=`i'+1
	}
egen sbar_5t=rowmean(tmp_1-tmp_12)
drop tmp_*
local i=1
while `i'<6{
		gen tmp_`i'=(s_`i't-sbar_`i't)/sds_`i'
		local i=`i'+1
	}
egen BigQ=rowmax(tmp_1-tmp_5)
drop tmp_* sbar_* s_* sds_*
* Ellison BIGSHARE2 variable
local i=1
while `i'<13{
		gen tmp_`i'=s1[_n-`i']
		local i=`i'+1
	}
egen sbar_1t=rowmean(tmp_1-tmp_12)
egen sds_1=sd(s1)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=s2[_n-`i']
		local i=`i'+1
	}
egen sbar_2t=rowmean(tmp_1-tmp_12)
egen sds_2=sd(s2)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=s3[_n-`i']
		local i=`i'+1
	}
egen sbar_3t=rowmean(tmp_1-tmp_12)
egen sds_3=sd(s3)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=s4[_n-`i']
		local i=`i'+1
	}
egen sbar_4t=rowmean(tmp_1-tmp_12)
egen sds_4=sd(s4)
drop tmp_*
local i=1
while `i'<13{
		gen tmp_`i'=s5[_n-`i']
		local i=`i'+1
	}
egen sbar_5t=rowmean(tmp_1-tmp_12)
egen sds_5=sd(s5)
drop tmp_*
local i=1
while `i'<6{
		gen tmp_`i'=(s`i'-sbar_`i't)/sds_`i'
		local i=`i'+1
	}
egen Big2=rowmax(tmp_1-tmp_5)
drop tmp_* sbar_* 
rename po PO
sort t
save "${dataout}Datageneration2.dta", replace

* File to be used in Matlab for Maximum Likelihood Estimation of PN as in Lee and Porter
keep t L GR PO Q
saveold "${dataout}railPO.dta", replace 

use "${dataout}Datageneration2.dta", clear
* File to be used in Matlab for Maximum Likelihood Estimation of PRN as in Lee and Porter
keep t L GR PR Q
saveold "${dataout}railPR.dta", replace 

* File converted from a Matlab datafile with the Maximum Likelihood Estimation of PN
use "${datain}pn.dta", clear
rename col1 t
rename col2 PN
drop col*
sort t
merge t using "${dataout}Datageneration2.dta"
drop _merge
sort t
save "${dataout}Datageneration2.dta", replace
* File converted from a Matlab datafile with the Maximum Likelihood Estimation of PRN
use "${datain}pnnew.dta", clear
rename col1 t
rename col2 PRN
drop col*
sort t
merge t using "${dataout}Datageneration2.dta"
drop _merge
tsset t
gen MNCY=GPN-GP1N /* Marginal Net Convenience Yield */
gen GRstar=GP1N-GPC /* Proxy Outside Option Transportation Cost*/
replace GRstar=0.01 if GRstar<0 /* Replace 3 negative values with a low number */
corr GR GRLC GRLR GRstar
gen grstar=log(GRstar)
gen GP1N_1=L.GP1N
gen ER=GP1N_1-GPN
gen q_1=q[_n-1]
keep t year PO PN PRN PR Q GR q q_1 L gr m1-m12 yr1-yr6 S1-S4 N NWO NWC ER BigQ Big1 Big2 Small1 MNCY grstar
save "${dataout}Datageneration2.dta", replace

*File to be used in R for the semiparametric estimations, whose results are reported in Table 6 p. 1735 of the article.
gen cons=1
gen PR1=PR[_n+1]
*EStimation here below is only useful to get the right number of missing values, so to facilitate the use of R
arima PR1 N L NWO NWC Small1 ER, arima(1,0,1) vce(r)
predict PRhat 
drop if PRhat==.|grstar==.|MNCY==.
keep L gr S1-S4 m1-m12 yr1-yr6 NWC NWO MNCY q q_1 grstar PRhat cons t 
saveold "${datain}nonparam.dta", replace
