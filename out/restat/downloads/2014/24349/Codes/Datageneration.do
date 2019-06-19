/************* Replication of Porter's estimations *******************/
clear all
set mem 100m
set more off
global datain  "C:\Dropbox\LakespaperREStat\Data\"
global dataout "C:\Dropbox\LakespaperREStat\Results\"
global datatmpt "C:\Dropbox\LakespaperREStat\Temp\"
global fig "C:\Dropbox\LakespaperREStat\Figures\"

/* Variable GR comes from JS2.xls (multiplied by 100 to avoid problems with double precision values). The file JS2.xls is the original Porter dataset.
   I have past and copied the data in the Stata data editor. 
   The other variables come from Coleman's Transport Prices Chicago-NY.xls. I have used columns Z-AB. 
   Since the weeks in Coleman have one week lead to those in Porter, I have copied the data with one week lag. In this way All Railroads and JEC
   are comparable
*/
use "${datain}origincoleman.dta", clear
rename var1 date
rename var2 GRLC
rename var3 GRLR
rename var4 AllGR
rename var5 GR

*Coleman's rates were in bushels and to be consistent with Porter's data I have converted them in 100 lbr.
replace AllGR=round(AllGR*23.438/13.125)/100
replace GRLR=(GRLR*23.438/13.125)/100
replace GRLC=(GRLC*23.438/13.125)/100
replace GR=GR/100

*Our collusion variable
gen PR=(GR==AllGR) /* Deviations dummy when JEC differs from All Railroads */

*Generate the week identifier
gen double t=date(date, "DMY", 1899)
egen tmp=min(t)
replace t=t-tmp
replace t=1+(t/7)
gen yrstr=substr(date,8,2)
gen year=real(yrstr)
egen minyr=min(year)
gen W=(year-minyr)*52
gen wk=t-W
drop tmp
drop if year<80|year>86
drop t 
gen double t=date(date, "DMY", 1899)
egen tmp=min(t)
replace t=t-tmp
replace t=1+(t/7)
drop if t>328
drop tmp
sort t 
save "${datatmp}tmp.dta", replace
use "${datain}origincolemanfutures.dta", clear

* N New York spot grain price, C Chicago spot grain price. 0=Future grain price for delivery within the month; 
* 1=Future grain price for delivery within next month. 2=Future grain price for delivery within two months (not available for Chicago)
rename var1 date
rename var2 GPN
rename var3 GP0N
rename var4 GP1N
rename var12 GP2N
rename var7 GPC
rename var8 GP0C
rename var9 GP1C

*Convert Coleman's prices in bushels into Porter's rates in 100 lbr.
replace GPN=(GPN*23.438/13.125)/100
replace GP0N=(GP0N*23.438/13.125)/100
replace GP1N=(GP1N*23.438/13.125)/100
replace GP2N=(GP2N*23.438/13.125)/100
replace GPC=(GPC*23.438/13.125)/100
replace GP0C=(GP0C*23.438/13.125)/100
replace GP1C=(GP1C*23.438/13.125)/100
gen GP2N_8=GP2N[_n-8]
gen GP1C_4=GP1C[_n-4]
gen GP0N_1=GP0N[_n-1]
*Converts Coleman's dates into Porter's dates
gen double t=date(date, "DMY", 1899)
egen tmp=min(t)
replace t=t-tmp
replace t=1+(t/7)
gen yrstr=substr(date,8,2)
gen year=real(yrstr)
drop tmp

*Keep the relevant period
drop if year<80|year>86
drop t
gen double t=date(date, "DMY", 1899)
egen tmp=min(t)
replace t=t-tmp
replace t=1+(t/7)
drop if t>328
drop tmp
sort t
merge t using "${datatmp}tmp.dta"
drop _merge

* Differences in prices 
keep t GPN GP0N GP1N GP2N GPC GP1C GP2N_8 GP1C_4 GP0N_1
sort t
save "${datatmp}tmp1.dta", replace

* loading the firm-level information dataset
use "${datain}rail2.dta", clear
keep week ponew
rename week t
sort t
save "${datatmp}tmp2.dta", replace

* loading the firm-level information dataset
use "${datain}firmdata.dta", clear
drop gr /* Was GR in our notation, and we have already that variable */
sort t
merge t using "${datatmp}tmp.dta"
drop _merge
sort t
merge t using "${datatmp}tmp1.dta"
drop _merge
sort t
merge t using "${datatmp}tmp2.dta"
drop _merge

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

* Data to be used in Figures.do file and I run it only once, then comment
/*
gen tnew=t
keep tnew PR
sort tnew
save "${dataout}PRdata.dta"
*/

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

* replace year as to be sure years are of 52 weeks each (this follows the same logic than months in Porter)
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

*Generating the order of weeks in a month
egen tsh1=max(t), by(year mth)
gen tsh2=tsh1[_n]-tsh1[_n-1]
gen wkm=1 if tsh2!=0
replace wkm=2 if wkm[_n]==.&wkm[_n-1]==1
replace wkm=3 if wkm[_n]==.&wkm[_n-1]==2
replace wkm=4 if wkm[_n]==.&wkm[_n-1]==3
tab wkm, gen(wkm)

* Generating yearly cumulative number weeks Lakes are open, NWO, and yearly de-cumulative number of weeks to the opening of the Lakes, NWC.
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

* Generating yearly cumulative number weeks Lakes and Canals are open, NWOLC,
* and yearly de-cumulative number of weeks to the opening of the Lakes and Canals, NWCLR.
gen trash0=t if year==1880&LC==0&(t>=minwyr&t<intwyr)
egen tmp0=group(trash0)
egen tmp00=max(tmp0)
replace tmp0=tmp00-tmp0
gen trash1=t if (year==1880&LC==0&(t>=intwyr&t<=maxwyr))|(year==1881&LC==0&(t>=minwyr&t<intwyr))
egen tmp1=group(trash1)
egen tmp11=max(tmp1)
replace tmp1=tmp11-tmp1
gen trash2=t if (year==1881&LC==0&(t>=intwyr&t<=maxwyr))|(year==1882&LC==0&(t>=minwyr&t<intwyr))
egen tmp2=group(trash2)
egen tmp22=max(tmp2)
replace tmp2=tmp22-tmp2
gen trash3=t if (year==1882&LC==0&(t>=intwyr&t<=maxwyr))|(year==1883&LC==0&(t>=minwyr&t<intwyr))
egen tmp3=group(trash3)
egen tmp33=max(tmp3)
replace tmp3=tmp33-tmp3
gen trash4=t if (year==1883&LC==0&(t>=intwyr&t<=maxwyr))|(year==1884&LC==0&(t>=minwyr&t<intwyr))
egen tmp4=group(trash4)
egen tmp44=max(tmp4)
replace tmp4=tmp44-tmp4
egen NWCLC=rowtotal(tmp0 tmp1 tmp2 tmp3 tmp4)
drop trash* tmp*
gen trash0=t if year==1880&LC==1
egen tmp0=group(trash0)
gen trash1=t if year==1881&LC==1 
egen tmp1=group(trash1)
gen trash2=t if year==1882&LC==1
egen tmp2=group(trash2)
gen trash3=t if year==1883&LC==1
egen tmp3=group(trash3)
egen NWOLC=rowtotal(tmp0 tmp1 tmp2 tmp3)
drop trash* tmp*

* Generating yearly cumulative number weeks Lakes and Railroads are open, NWOLR,
* and yearly de-cumulative number of weeks to the opening of the Lakes and Railroads, NWCLR.
gen trash0=t if year==1880&LR==0&(t>=minwyr&t<intwyr)
egen tmp0=group(trash0)
egen tmp00=max(tmp0)
replace tmp0=tmp00-tmp0
gen trash1=t if (year==1880&LR==0&(t>=intwyr&t<=maxwyr))|(year==1881&LR==0&(t>=minwyr&t<intwyr))
egen tmp1=group(trash1)
egen tmp11=max(tmp1)
replace tmp1=tmp11-tmp1
gen trash2=t if (year==1881&LR==0&(t>=intwyr&t<=maxwyr))|(year==1882&LR==0&(t>=minwyr&t<intwyr))
egen tmp2=group(trash2)
egen tmp22=max(tmp2)
replace tmp2=tmp22-tmp2
gen trash3=t if (year==1882&LR==0&(t>=intwyr&t<=maxwyr))|(year==1883&LR==0&(t>=minwyr&t<intwyr))
egen tmp3=group(trash3)
egen tmp33=max(tmp3)
replace tmp3=tmp33-tmp3 
gen trash4=t if (year==1883&LR==0&(t>=intwyr&t<=maxwyr))|(year==1884&LR==0&(t>=minwyr&t<intwyr))
egen tmp4=group(trash4)
egen tmp44=max(tmp4)
replace tmp4=tmp44-tmp4
gen trash5=t if (year==1884&LR==0&(t>=intwyr&t<=maxwyr))|(year==1885&LR==0&(t>=minwyr&t<intwyr))
egen tmp5=group(trash5)
egen tmp55=max(tmp5)
replace tmp5=tmp55-tmp5
gen trash6=t if (year==1885&LR==0&(t>=intwyr&t<=maxwyr))|(year==1886&LR==0&(t>=minwyr&t<intwyr))
egen tmp6=group(trash6)
egen tmp66=max(tmp6)
replace tmp6=tmp66-tmp6
egen NWCLR=rowtotal(tmp0 tmp1 tmp2 tmp3 tmp4 tmp5 tmp6)
drop trash* tmp*
gen trash0=t if year==1880&LR==1
egen tmp0=group(trash0)
gen trash1=t if year==1881&LR==1
egen tmp1=group(trash1)
gen trash2=t if year==1882&LR==1
egen tmp2=group(trash2)
gen trash3=t if year==1883&LR==1
egen tmp3=group(trash3)
gen trash4=t if year==1884&LR==1
egen tmp4=group(trash4)
gen trash5=t if year==1885&LR==1
egen tmp5=group(trash5)
gen trash6=t if year==1886&LR==1
egen tmp6=group(trash6)
egen NWOLR=rowtotal(tmp0 tmp1 tmp2 tmp3 tmp4 tmp5 tmp6)
drop trash* tmp*
sort t
save "${datatmp}rail.dta", replace

use "${datain}pn.dta", clear
rename col1 t
rename col2 pn
drop col*
sort t
merge t using "${datatmp}rail.dta"
drop _merge
sort t
save "${datatmp}rail.dta", replace
use "${datain}pnnew.dta", clear
rename col1 t
rename col2 PRN
drop col*
sort t
merge t using "${datatmp}rail.dta"
drop _merge

gen cpo=sum(po)
gen cpn=sum(pn)
gen cpr=sum(PR)
gen cprn=sum(PRN)
twoway scatter cpo t, ms(i) c(l) clpattern(dash) lw(medium) cmissing(n) || scatter cpn t, ms(i) c(l) clpattern(dot) lw(medium) cmissing(n) || /*
*/ scatter cpr t, ms(i) c(l) clpattern(solid) lw(medium) cmissing(n) || scatter cprn t, ms(i) c(l) clpattern(dash_dot) lw(medium) cmissing(n) xtitle(week) /*
*/ ytitle(week) xlabel(0(52)328) ylabel(0(52)328) legend(off) lpattern(l -) color(black black) scheme(s1manual)

* Differences in rates
gen MNCY=GPN-GP0N /* Marginal Net Convenience Yield */
gen GRstar=GP0N-GPC /* Proxy Outside Option Transportation Cost*/
replace GRstar=0.01 if GRstar<0 /* Replace 3 negative values with a low number */
corr GR GRLC GRLR GRstar
gen grstar=log(GRstar)
gen GRstar1=GP2N-GP1C
replace GRstar1=0.01 if GRstar1<0 /* Replace 3 negative values with a low number */
gen grstar1=log(GRstar1)
gen ER=GP0N_1-GPN
gen ER1=(GP2N_8-GPN)-(GP1C_4-GPC)

/*
* Figures
replace NWO=. if NWO==0
replace NWC=. if NWC==0
twoway scatter NWO t, ms(+) cmissing(n) || scatter NWC t, ms(*) cmissing(n) xtitle(weeks) /*
*/ ytitle(Number Weeks to L opening/L Open) xlabel(0(52)328) ylabel(0(5)35) legend(off)/*
*/ saving("${fig}NWONWC.gph", replace) lpattern(l -) color(black black) scheme(s1manual)
replace NWO=0 if NWO==.
replace NWC=0 if NWC==.

replace NWOLC=. if NWOLC==0
replace NWCLC=. if NWCLC==0
twoway scatter NWOLC t, ms(+) cmissing(n) || scatter NWCLC t, ms(*) cmissing(n) xtitle(weeks) /*
*/ ytitle(Number Weeks to L opening/L Open) xlabel(0(52)328) ylabel(0(5)35) legend(off)/*
*/ saving("${fig}NWONWCLC.gph", replace) lpattern(l -) color(black black) scheme(s1manual)
replace NWOLC=0 if NWOLC==.
replace NWCLC=0 if NWCLC==.

replace NWOLR=. if NWOLR==0
replace NWCLR=. if NWCLR==0
twoway scatter NWOLR t, ms(+) cmissing(n) || scatter NWCLR t, ms(*) cmissing(n) xtitle(weeks) /*
*/ ytitle(Number Weeks to L opening/L Open) xlabel(0(52)328) ylabel(0(5)35) legend(off)/*
*/ saving("${fig}NWONWCLR.gph", replace) lpattern(l -) color(black black) scheme(s1manual)
replace NWOLR=0 if NWOLR==.
replace NWCLR=0 if NWCLR==.
*/

* Quantities
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

sum A S

* Absolute Deviations 
gen d1=abs(a1-s1)
gen d2=abs(a2-s2)
gen d3=abs(a3-s3)
gen d4=abs(a4-s4)
gen d5=abs(a5-s5)

* Herfindahl index of alloted market shares
gen H=(a1^2+a2^2+a3^2+a4^2+a5^2)

* Sum of Squared Deviations of Actual from Alloted market shares
gen SSD=(d1^2+d2^2+d3^2+d4^2+d5^2)

* Total number weeks L, LC, LR to NWO and NWC
egen NW=rowtotal(NWO NWC)
egen NWLC=rowtotal(NWOLC NWCLC)
egen NWLR=rowtotal(NWOLR NWCLR)

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

summ N L NWO NWC Q GR GRLC Big1 Big2 BigQ Small1 MNCY GRstar GRstar1 ER ER1 

* Lagged variables to be used it the Linear Probability estimation of PR
gen q_1=q[_n-1]
gen H_1=H[_n-1]
gen N_1=N[_n-1]
gen SSD_1=SSD[_n-1]
gen L_1=L[_n-1]
gen LR_1=LR[_n-1]
gen NW_1=NW[_n-1]
gen NWLR_1=NWLR[_n-1]
gen grLR_1=grLR[_n-1]
gen PR_1=PR[_n-1]
*gen PRop_1=PRop[_n-1]
gen NWO_1=NWO[_n-1]
gen NWC_1=NWC[_n-1]
gen grstar_1=grstar[_n-1]
gen MNCY_1=MNCY[_n-1]
gen Big1_1=Big1[_n-1]
gen Big2_1=Big2[_n-1]
gen BigQ_1=BigQ[_n-1]
gen Small1_1=Small1[_n-1]
gen PR1=PR[_n+1]
*gen PR1op=PRop[_n+1]
gen ER_1=ER[_n-1]
gen ER1_1=ER1[_n-1]

* Extrapolate business cycle from Q (variable BCQ)
tsset t
hprescott q, stub(HP)
rename HP_q_sm_1 BCq1
gen Deviations=PR+8
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=8*Lakesopen
gen Lakesopen1=1.5*Lakesopen
* Plot Total demand and its business cycle
twoway scatter q t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCq1 t, ms(i) c(l) lw(thick) sort xlabel(0(52)328) /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen1 t, ms(d) mc(black) cmissing(n) saving("${fig}QBC.gph", replace) /*
*/ ytitle(Log Quantity) xtitle(Week) legend(off) lpattern(l -) color(black black) scheme(s1manual)
drop Lakesopen* Deviations

gen boom=BCq1[_n]>BCq1[_n-1]
gen rec=BCq1[_n]<=BCq1[_n-1]
save "${datatmp}rail.dta", replace
sort t
rename po PO
gen const=1
table const, c(sum PO sum PR) 
keep t L GR PO Q
saveold "${dataout}railPO.dta", replace /* File used in Matlab for ML with PO */

use "${datatmp}rail.dta", clear
sort t
keep t L GR PR Q
saveold "${dataout}railPR.dta", replace /* File used in Matlab for ML with PR */

use "${datatmp}rail.dta", clear
rename po PO
save "${dataout}estimations.dta", replace

/*
*REGRESSIONS 2SLS PO and PR
* 2SLS regression of the supply and demand equations. Table 3 col. I Porter (1983), Porter (1983) Without Year Dummies
reg3 (q L gr m1-m12) (gr q S1-S4 PO m1-m12), 2sls
gen pcm=1-exp(-([gr]PO)*PO)
*egen tmp=max(pcm)
*replace pcm=pcm-tmp
replace pcm=. if PO==0

reg3 (q L gr m1-m12 yr1-yr6) (gr q S1-S4 PO m1-m12), 2sls /* With year dummies */
outreg2 L gr S1 S2 S3 S4 PO q using "${dataout}tablePorter", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex append
gen pcmyr=1-exp(-([gr]PO)*PO)
*drop tmp
*egen tmp=max(pcmyr)
*replace pcmyr=pcmyr-tmp
replace pcmyr=. if PO==0

* 2SLS regression of the supply and demand equations. PR Without Year Dummies
reg3 (q L gr m1-m12) (gr q S1-S4 PR m1-m12), 2sls
outreg2 L gr S1 S2 S3 S4 PO q using "${dataout}tablePorter", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex replace
gen pcm=1-exp(-([gr]PO)*PO)
*egen tmp=max(pcm)
*replace pcm=pcm-tmp
replace pcm=. if PO==0

reg3 (q L gr m1-m12 yr1-yr6) (gr q S1-S4 PR m1-m12), 2sls /* PR With year dummies */
outreg2 L gr S1 S2 S3 S4 PO q using "${dataout}tablePorter", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex append
gen pcmyr=1-exp(-([gr]PO)*PO)
*drop tmp
*egen tmp=max(pcmyr)
*replace pcmyr=pcmyr-tmp
replace pcmyr=. if PO==0


* Using our Deviations dummy PR
reg3 (q L gr m1-m12) (gr q S1-S4 PR m1-m12), 2sls
gen pcmPR=1-exp(-([gr]PR)*PR)
replace pcmPR=. if PR==0

outreg2 L gr S1 S2 S3 S4 PR q using "${dataout}tablePorterponew", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex replace
reg3 (q L gr m1-m12 yr3 yr6 yr7) (gr q S1-S4 PR m1-m12 yr2-yr7), 2sls /* With year dummies */
outreg2 L gr S1 S2 S3 S4 PR q using "${dataout}tablePorterponew", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex append
gen pcmyrPR=1-exp(-([gr]PR)*PR)
replace pcmyrPR=. if PR==0

* Figure of 2SLS pcms
twoway scatter pcm t, ms(i) c(l) clpattern(line) sort lwidth(medium) cmissing(n) || scatter pcmyr t, ms(i) c(l) clpattern(line) sort lwidth(medium) cmissing(n) /*
*/|| scatter pcmPR t, ms(i) c(l) clpattern(line) sort lwidth(medium) cmissing(n) || scatter pcmyrPR t, ms(i) c(l) clpattern(line) lwidth(medium) sort /*
*/ cmissing(n) xtitle(Weeks) ytitle(Excessive PCM in Stable Periods) xlabel(0(52)328) ylabel(.2(.1).5) legend(off) saving(C:\LakesPaper\Figures\pcm2SLS, replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

*/

egen BCqmax=max(BCq1)
egen NWmax=max(NW)
gen NWsc=(NW*BCqmax)/NWmax
egen NWCmax=max(NWC)
gen NWCsc=(NWC*BCqmax)/NWCmax
egen NWOmax=max(NWO)
gen NWOsc=(NWO*BCqmax)/NWOmax
egen GRstarmax=max(GRstar)
gen GRstarsc=(GRstar*BCqmax)/GRstarmax
gen Lakesopen=L
replace Lakesopen=. if L==0
gen Lakesopen1=12*Lakesopen
gen Deviations=PR
replace Deviations = . if PR==1
twoway scatter NWsc t, ms(i) c(j) clpattern(dash) lwidth(medium) sort || scatter BCq1 t, ms(i) c(l) lwidth(thick) sort xlabel(0(52)328) ||scatter Lakesopen1 t, ms(d) mc(black) cmissing(n)/*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) || scatter GRstarsc t, ms(i) c(l) clpattern(.) lwidth(thick) cmissing(n) saving("${fig}NWGRst.gph", replace) /*
*/ xtitle(Weeks) xlabel(0(52)328) legend(off) lpattern(l -) color(black black) scheme(s1manual)
pwcorr NWC BCq1 GRstarsc, star(0.01)
pwcorr NWCsc BCq1 GRstarsc if NWCsc!=., star(0.01)
pwcorr NWOsc BCq1 GRstarsc if NWOsc!=., star(0.01)
stop


/********************************* OUR ESTIMATIONS ******************************/
* Using our full information and full time period (no lakes and canals variables)
*markov PRop

arima PR1 N L NWO NWC ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop PRhat PRnew tmp

arima PR1 N L NWO NWC Big1 ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop PRhat PRnew tmp

arima PR1 N L NWO NWC Big2 ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop PRhat PRnew tmp

arima PR1 N L NWO NWC BigQ ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop PRhat PRnew tmp

arima PR1 N L NWO NWC Small1 ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop tmp
/*
gen cons=1
drop if PRhat==.|grstar==.|MNCY==.
keep L gr S1-S4 m1-m12 yr1-yr6 NWC NWO MNCY q q_1 grstar PRhat cons t 
saveold "${datain}nonparam.dta", replace
*/
*sort MNCY
*gen dlow=_n<=10
*replace dlow=. if MNCY==.
*gsort - MNCY
*gen dhigh=_n<=10
*replace dhigh=. if MNCY==.
*sort t
egen hpct=pctile(MNCY), p(99)
replace hpct=. if MNCY==.
egen lpct=pctile(MNCY), p(1)
replace lpct=. if MNCY==.
gen dMNCYhigh=MNCY>hpct
replace dMNCYhigh=. if MNCY==.
gen dMNCYlow=MNCY<lpct
replace dMNCYlow=. if MNCY==.
gen hMNCY=dMNCYhigh*MNCY
*gen lMNCY=dMNCYlow*MNCY
gen mMNCY=(1-dMNCYhigh)*MNCY

* 2SLS Regression (Linear)
xi: reg3 (q L gr dMNCYhigh dMNCYlow MNCY NWO NWC grstar m1-m12 yr1-yr6) (gr NWO NWC q PRhat grstar m1-m12 S1-S4), 2sls/* With year dummies */                                 
gen om1=[q]NWO*NWO+[q]NWC*NWC+[q]MNCY*MNCY+[q]dMNCYhigh*dMNCYhigh+[q]dMNCYlow*dMNCYlow
summ om1
test [q]NWO [q]NWC [q]MNCY [q]dMNCYhigh [q]dMNCYlow
gen om2=[gr]PRhat*PRhat+[gr]NWO*NWO+[gr]NWC*NWC+[gr]grstar*grstar
summ om2
test [gr]PRhat [gr]NWO [gr]NWC [gr]grstar
gen pcm=1-exp(-[gr]PRhat*PRhat-[gr]NWO*NWO-[gr]NWC*NWC-[gr]grstar*grstar)
summ pcm
gen PCM=pcm /* Variables used to determine the business cycles */

predict quhat, eq(q) r
predict gruhat, eq(gr) r
gen tmpq=q
gen tmpgr=gr
replace tmpq=. if quhat==.|gruhat==.
replace tmpgr=. if quhat==.|gruhat==.
egen mq=mean(tmpq)
egen mgr=mean(tmpgr)
gen tmp1=(quhat)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(q-mq)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2d=1-stmp1/stmp2
drop stmp* tmp*
gen tmp1=(gruhat)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(gr-mgr)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2s=1-stmp1/stmp2
summ r2d r2s
drop stmp* tmp* r2*

gen quhat1=quhat+om1
gen tmpom1=om1
replace tmpom1=. if quhat==.|gruhat==.
gen tmpom2=om2
replace tmpom2=. if quhat==.|gruhat==.
egen mom1=mean(tmpom1)
gen gruhat1=gruhat+om2
egen mom2=mean(tmpom2)
gen tmp1=(quhat1-mom1)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(q-mq)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2d=1-stmp1/stmp2
drop stmp* tmp*
gen tmp1=(gruhat1-mom2)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(gr-mgr)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2s=1-stmp1/stmp2
summ r2d r2s
drop stmp* tmp* r2* quhat* gruhat* mq mgr mom1 mom2 tmp*


* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.

* Extrapolate business cycle from PCM (variable BCpcm)
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
replace Lakesopen=Lakesopen/2
* Plot pcm and its business cycles
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) /*
*/ ylabel(-.5(.5).5) ytitle(Estimated PCM and Estimated PCM Cycles) /*
*/ xtitle(Week [Linear]) legend(off) saving("${fig}pcmBCpoly.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

pctile pct = q, nq(10)
egen tmp_min=min(pct)
egen tmp_max=max(pct)
gen boomRS=q>tmp_max
gen recRS=q<tmp_min
probit PR boomRS recRS N

gen BCq2= BCq1^2
gen BCq3= BCq1^3
gen BCq4= BCq1^4
reg BCpcm BCq1 BCq2 BCq3 N if boom==1&PR==1
test BCq1 BCq2 BCq3 
predict BCpcm_up_hat if PR==1
reg BCpcm BCq1 BCq2 BCq3 N if rec==1&PR==1
test BCq1 BCq2 BCq3
predict BCpcm_down_hat if PR==1

*Plot PCMs Booms Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCq1, ms(i) c(j) lpattern(l) sort cmissing(n)||scatter BCpcm_down_hat BCq1, ms(i) c(j) clpattern(dash) lwidth(thick) /* 
*/ cmissing(n) sort ylabel(.1(.1).6) xtitle(q [Linear]) ytitle(Estimated PCM Booms and Recessions) legend(off) /*
*/ saving("${fig}pcmu_dBCQBCpoly.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

egen BCqmin=min(BCq1)
egen tmpBCq=max(BCq1-BCqmin)
gen BCqnorm=(BCq1-BCqmin)/(2*tmpBCq)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCqnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t,  ms(t) mc(black) cmissing(n) ||scatter Lakesopen t,  ms(d) mc(black) cmissing(n) xlabel(0(52)328) /*
*/ ylabel(0(.1).5) ytitle(Quantitity and Estimated PCM Cycles) xtitle(Weeks [Linear]) legend(off) /*
*/ saving("${fig}pcmBCQBCpoly.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

gen profit=GR*pcm*Q/10000
replace Lakesopen=2*Lakesopen

* Extrapolate business cycle from PROF (variable BCprofit)
gen PROF=profit /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit
* Plot Estimated Profit and its business cycles
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t,  ms(t) mc(black) cmissing(n) ||scatter Lakesopen t,  ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-0.5(.5)1) /*
*/ ytitle(Estimated Profit Cycles) xtitle(Weeks [Linear]) legend(off) saving("${fig}profBCpoly.gph", replace) lpattern(l -)/*
*/ color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t,  ms(t) mc(black) cmissing(n) ||scatter Lakesopen t,  ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(0.1)0.5)/*
*/ ytitle(Quantitity and Estimated Profit Cycles) xtitle(Weeks [Linear]) legend(off) saving("${fig}profBCQBCpoly.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

drop pcm om1 om2 profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Deviations Lakesopen*

/************** Regression with Partial Adjustment Model **********************/

* 2SLS Regression (Polynomial of order one)
xi: reg3 (q q_1 L gr NWO NWC dMNCYhigh dMNCYlow MNCY  grstar yr1-yr6 m1-m12) (gr NWO NWC q PRhat grstar m1-m12 S1-S4), 2sls /* With year dummies */
gen om1=[q]NWO*NWO+[q]NWC*NWC+[q]MNCY*MNCY+[q]dMNCYhigh*dMNCYhigh+[q]dMNCYlow*dMNCYlow
summ om1
test [q]NWO [q]NWC [q]MNCY [q]dMNCYhigh [q]dMNCYlow
gen om2=[gr]PRhat*PRhat+[gr]NWO*NWO+[gr]NWC*NWC+[gr]grstar*grstar
summ om2
test [gr]PRhat [gr]NWO [gr]NWC [gr]grstar
gen pcm=1-exp(-[gr]PRhat*PRhat-[gr]NWO*NWO-[gr]NWC*NWC-[gr]grstar*grstar)
summ pcm
gen PCM=pcm /* Variables used to determine the business cycles */

predict quhat, eq(q) r
predict gruhat, eq(gr) r
gen tmpq=q
gen tmpgr=gr
replace tmpq=. if quhat==.|gruhat==.
replace tmpgr=. if quhat==.|gruhat==.
egen mq=mean(tmpq)
egen mgr=mean(tmpgr)
gen tmp1=(quhat)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(q-mq)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2d=1-stmp1/stmp2
drop stmp* tmp*
gen tmp1=(gruhat)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(gr-mgr)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2s=1-stmp1/stmp2
summ r2d r2s
drop stmp* tmp* r2*

gen quhat1=quhat+om1
gen tmpom1=om1
replace tmpom1=. if quhat==.|gruhat==.
gen tmpom2=om2
replace tmpom2=. if quhat==.|gruhat==.
egen mom1=mean(tmpom1)
gen gruhat1=gruhat+om2
egen mom2=mean(tmpom2)
gen tmp1=(quhat1-mom1)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(q-mq)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2d=1-stmp1/stmp2
drop stmp* tmp*
gen tmp1=(gruhat1-mom2)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(gr-mgr)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2s=1-stmp1/stmp2
summ r2d r2s
drop stmp* tmp* r2* quhat* gruhat* mq mgr mom1 mom2 tmp*

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.

* Extrapolate business cycle from PCM (variable BCpcm)
gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
* Plot pcm and its business cycles
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(Estimated PCM Cycles) /*
*/ xtitle(Weeks [Linear with PA]) legend(off) saving("${fig}pcmBCpoly_1.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

*Plot PCMs Booms Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ylabel(.1(.1).6) xtitle(Q [Linear with PA]) ytitle(Estimated PCM Booms and Recessions) legend(off) saving("${fig}pcmu_dBCQBCpoly_1.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated PCM Cycles) xtitle(Weeks [Linear with PA]) legend(off) saving("${fig}pcmBCQBCpoly_1.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

gen profit=GR*pcm*Q/10000
replace Lakesopen=2*Lakesopen
* Extrapolate business cycle from PROF (variable BCprofit)
gen PROF=profit /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit
* Plot Estimated Profit and its business cycles
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort ||scatter Deviations t, /*
*/ ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5)1) ytitle(Estimated Profit Cycles)/*
*/ xtitle(Weeks [Linear with PA]) legend(off) saving("${fig}profBCpoly_1.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated Profit Cycles) xtitle(Weeks [Linear with PA]) legend(off) saving("${fig}profBCQBCpoly_1.gph", replace)/*
*/ lpattern(l -) color(black black) scheme(s1manual)

drop om1 om2 pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Lakesopen* Deviations

/************ Import Data from Kernel Estimation of PCM ********************/
sort t
merge t using "${datain}pcm.dta"
drop _merge
summ pcm
gen PCM=pcm /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen

* Extrapolate business cycle from PCM (variable BCpcm)
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
* Plot pcm and its business cycles
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(Estimated PCM Cycles) /*
*/ xtitle(Weeks [semiparametric]) legend(off) saving("${fig}pcmBCkrnl.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

*Plot PCMs Booms Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ylabel(.1(.1).6) xtitle(Q [semiparametric]) ytitle(Estimated PCM Booms and Recessions) legend(off) saving("${fig}pcmu_dBCQBCkrnl.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated PCM Cycles) xtitle(Weeks [semiparametric]) legend(off) saving("${fig}pcmBCQBCkrnl.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

gen profit=GR*pcm*Q/10000
replace Lakesopen=2*Lakesopen
* Extrapolate business cycle from PROF (variable BCprofit)
gen PROF=profit /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit
* Plot Estimated Profit and its business cycles
replace profit=. if profit>1 /*It is ony one observation, just to have more comparable Figures*/
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5)1)/*
*/ ytitle(Estimated Profit Cycles) xtitle(Weeks [semiparametric]) legend(off) saving("${fig}profBCkrnl.gph", replace) lpattern(l -)/*
*/ color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5)/*
*/ ytitle(Quantitity and Estimated Profit Cycles) xtitle(Weeks [semiparametric]) legend(off) saving("${fig}profBCQBCkrnl.gph", replace)/*
*/ lpattern(l -) color(black black) scheme(s1manual)

drop pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Lakesopen* Deviation

/************ Import Data from Kernel Estimation with Dynamic Adjustment of PCM ********************/
sort t
merge t using "${datain}pcmlag.dta"
drop _merge
summ pcm
gen PCM=pcm /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen

* Extrapolate business cycle from PCM (variable BCpcm)
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
* Plot pcm and its business cycles
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(Estimated PCM Cycles) /*
*/ xtitle(Weeks [semiparametric with PA]) legend(off) saving("${fig}pcmBCkrnl_1.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

*Plot PCMs Booms Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ylabel(.1(.1).6) xtitle(Q [semiparametric with PA]) ytitle(Estimated PCM Booms and Recessions) legend(off) saving("${fig}pcmu_dBCQBCkrnl_1.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /* 
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated PCM Cycles) xtitle(Weeks [semiparametric with PA]) legend(off) saving("${fig}pcmBCQBCkrnl_1.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

gen profit=GR*pcm*Q/10000
replace Lakesopen=2*Lakesopen
* Extrapolate business cycle from PROF (variable BCprofit)
gen PROF=profit /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit
* Plot Estimated Profit and its business cycles
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /* 
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5)1) /*
*/ ytitle(Estimated Profit Cycles) xtitle(Weeks [semiparametric with PA]) legend(off) saving("${fig}profBCkrnl_1.gph", replace)/*
*/ lpattern(l -) color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated Profit Cycles) xtitle(Weeks [semiparametric with PA]) legend(off) saving("${fig}profBCQBCkrnl_1.gph", replace)/*
*/ lpattern(l -) color(black black) scheme(s1manual)

drop pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Lakesopen* Deviations

* Save file to be used in Matlab for Kernel estimation
drop PRhat
arima PR GF_1 GFT_1 N_1 L_1 NWO_1 NWC_1 Big1_1 Big2_1 BigQ_1 Small1_1 ER_1, ar(1)
predict PRhat 
replace PRhat=F.PRhat

keep t PRhat q q_1 gr L NWO NWC grstar MNCY S1-S4
drop if PRhat==.|grstar==.
saveold "${dataout}railKernel.dta", replace

use "${dataout}estimations.dta", clear


/*
/********************************* OUR ESTIMATIONS WITH LAGGED ERRORS ******************************/
* Using our full information and full time period (no lakes and canals variables)
tsset t
arima PR GF_1 GFT_1 N_1 L_1 NWO_1 NWC_1 Big1_1 Big2_1 BigQ_1 Small1_1 ER_1 ER1_1, arima(1,0,1) vce(opg)

predict PRhat 
replace PRhat=F.PRhat
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.

* Copy Table results in latex
outreg2 q_1 GF_1 GFT_1 N_1 L_1 NWO_1 NWC_1 Big1_1 Big2_1 BigQ_1 Small1_1 ER_1 ER1_1 L gr NWO NWC grstar MNCY q PRhat using "${dataout}tableMWER", bdec(3) tex replace

* 2SLS Regression (Polynomial of order one)
xi: reg3 (q L gr NWO NWC grstar MNCY m1-m12 yr3 yr6 yr7) (gr NWO NWC q PRhat grstar MNCY m1-m12 yr2-yr7), 2sls /* With year dummies */
outreg2 q_1 GF_1 GFT_1 N_1 L_1 NWO_1 NWC_1 Big1_1 Big2_1 BigQ_1 Small1_1 ER_1 ER1_1 L gr NWO NWC grstar MNCY q PRhat using "${dataout}tableMWER", bdec(3) /*
*/      addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex append           
                                 
gen pcm=1-exp(-[gr]PRhat*PRhat-[gr]NWO*NWO-[gr]NWC*NWC-[gr]grstar*grstar-[gr]MNCY*MNCY)
summ pcm
gen PCM=pcm /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.

* Extrapolate business cycle from PCM (variable BCpcm)
gen Deviations=PR
replace Deviations = . if PR==-1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
* Plot pcm and its business cycles
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5).5) /*
*/ ytitle(Estimated PCM Cycles) legend(off) saving(C:\LakesPaper\Figures\pcmBCpolyER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

* Extrapolate business cycle from Q (variable BCQ)
hprescott Q, stub(HP)
rename HP_Q_sm_1 BCQ1
gen Lakesopen1=160000*Lakesopen
gen boom=BCQ1[_n]>BCQ1[_n-1]
gen rec=BCQ1[_n]<=BCQ1[_n-1]

pctile pct = Q, nq(10)
egen tmp_min=min(pct)
egen tmp_max=max(pct)
gen boomRS=Q>tmp_max
gen recRS=Q<tmp_min
probit PR boomRS recRS N

gen BCQ2= BCQ1^2
gen BCQ3= BCQ1^3
gen BCQ4= BCQ1^4
reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

*Plot PCMs Booms Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort cmissing(n)||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) cmissing(n) sort /*
*/ xtitle(Q) ytitle(Estimated PCM Booms and Recessions) legend(off) saving(C:\LakesPaper\Figures\pcmu_dBCQBCpolyER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

egen BCQmin=min(BCQ1)
egen tmpBCQ=max(BCQ1-BCQmin)
gen BCQnorm=(BCQ1-BCQmin)/(2*tmpBCQ)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) /*
*/ ylabel(-.5(.5).5) ytitle(Quantitity and Estimated PCM Cycles) legend(off) saving(C:\LakesPaper\Figures\pcmBCQBCpolyER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

twoway scatter pcm t, ms(i) c(l) lpattern(l) sort cmissing(n)||scatter Deviations t, ms(+) cmissing(n)||scatter Lakesopen t, ms(+) cmissing(n) /*
*/ xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(Estimated PCM) legend(off) saving(C:\LakesPaper\Figures\pcmpolyER.eps, replace) lpattern(l -) color(black black)/*
*/ scheme(s1manual)
gen profit=pcm*Q/10000
replace Lakesopen=4*Lakesopen
twoway scatter profit t, ms(i) c(l) lpattern(l) sort cmissing(n)||scatter Deviations t, ms(+) cmissing(n)||scatter Lakesopen t, ms(+) cmissing(n) /*
*/ xlabel(0(52)328) ytitle(Estimated Profit) legend(off) saving(C:\LakesPaper\Figures\profpolyER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

* Extrapolate business cycle from PROF (variable BCprofit)
gen PROF=profit /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit
* Plot Estimated Profit and its business cycles
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) /*
*/ ytitle(Estimated Profit Cycles) legend(off) saving(C:\LakesPaper\Figures\profBCpolyER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328)/*
*/ ytitle(Quantitity and Estimated Profit Cycles) legend(off) saving(C:\LakesPaper\Figures\profBCQBCpolyER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

drop pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Deviations Lakesopen*
/*
/************** Regression with Partial Adjustment Model **********************/
* 2SLS Regression (Polynomial of order one)
xi: reg3 (q q_1 L gr NWO NWC grstar MNCY m1-m12 yr3 yr6 yr7) (gr NWO NWC q PRhat grstar MNCY m1-m12 yr2-yr7), 2sls /* With year dummies */
outreg2 q_1 GF_1 GFT_1 N_1 L_1 NWO_1 NWC_1 Big1_1 Big2_1 BigQ_1 Small1_1 ER_1 ER1_1 L gr NWO NWC grstar MNCY q PRhat using "${dataout}tableMWER", bdec(3) /*
*/      addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex append           

gen pcm=1-exp(-[gr]PRhat*PRhat-[gr]NWO*NWO-[gr]NWC*NWC-[gr]grstar*grstar-[gr]MNCY*MNCY)
summ pcm
gen PCM=pcm /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.

* Extrapolate business cycle from PCM (variable BCpcm)
gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
* Plot pcm and its business cycles
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(medium) sort /*
*/||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) /*
*/ ylabel(-.5(.5).5) ytitle(Estimated PCM Cycles) legend(off) saving(C:\LakesPaper\Figures\pcmBCpoly_1ER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

*Plot PCMs Booms Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ xtitle(Q) ytitle(Estimated PCM Booms and Recessions) legend(off) saving(C:\LakesPaper\Figures\pcmu_dBCQBCpoly_1ER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328)/*
*/ ylabel(-.5(.5).5) ytitle(Quantitity and Estimated PCM Cycles) legend(off) saving(C:\LakesPaper\Figures\pcmBCQBCpoly_1ER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

twoway scatter pcm t, ms(i) c(l) lpattern(l) sort cmissing(n)||scatter Deviations t, ms(+) cmissing(n)||scatter Lakesopen t, ms(+) cmissing(n) /*
*/ xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(Estimated PCM) legend(off) saving(C:\LakesPaper\Figures\pcmpoly_1ER.eps, replace) lpattern(l -) color(black black)/*
*/ scheme(s1manual)
gen profit=pcm*Q/10000
replace Lakesopen=4*Lakesopen
twoway scatter profit t, ms(i) c(l) lpattern(l) sort cmissing(n)||scatter Deviations t, ms(+) cmissing(n)||scatter Lakesopen t, ms(+) cmissing(n) /*
*/ xlabel(0(52)328) ytitle(Estimated Profit) legend(off) saving(C:\LakesPaper\Figures\profpoly_1ER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

* Extrapolate business cycle from PROF (variable BCprofit)
gen PROF=profit /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit
* Plot Estimated Profit and its business cycles
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) /*
*/ ytitle(Estimated Profit Cycles) legend(off) saving(C:\LakesPaper\Figures\profBCpoly_1ER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328)/*
*/ ytitle(Quantitity and Estimated Profit Cycles) legend(off) saving(C:\LakesPaper\Figures\profBCQBCpoly_1ER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

drop pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Lakesopen* Deviations

/************ Import Data from Kernel Estimation of PCM ********************/
sort t
merge t using "${datain}pcmkrnlER.dta"
drop _merge
summ pcm
gen PCM=pcm /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen

* Extrapolate business cycle from PCM (variable BCpcm)
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
* Plot pcm and its business cycles
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(medium) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) /*
*/ ylabel(-.5(.5).5) ytitle(Estimated PCM Cycles) legend(off) saving(C:\LakesPaper\Figures\pcmBCkrnlER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

*Plot PCMs Booms Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ xtitle(Q) ytitle(Estimated PCM Booms and Recessions) legend(off) saving(C:\LakesPaper\Figures\pcmu_dBCQBCkrnlER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328)/*
*/ ylabel(-.5(.5).5) ytitle(Quantitity and Estimated PCM Cycles) legend(off) saving(C:\LakesPaper\Figures\pcmBCQBCkrnlER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

twoway scatter pcm t, ms(i) c(l) lpattern(l) sort cmissing(n)||scatter Deviations t, ms(+) cmissing(n)||scatter Lakesopen t, ms(+) cmissing(n) /*
*/ xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(Estimated PCM) legend(off) saving(C:\LakesPaper\Figures\pcmkrnlER.eps, replace) lpattern(l -) color(black black)/*
*/ scheme(s1manual)
gen profit=pcm*Q/10000
replace Lakesopen=4*Lakesopen
twoway scatter profit t, ms(i) c(l) lpattern(l) sort cmissing(n)||scatter Deviations t, ms(+) cmissing(n)||scatter Lakesopen t, ms(+) cmissing(n) /*
*/ xlabel(0(52)328) ytitle(Estimated Profit) legend(off) saving(C:\LakesPaper\Figures\profkrnlER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

* Extrapolate business cycle from PROF (variable BCprofit)
gen PROF=profit /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit
* Plot Estimated Profit and its business cycles
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) /*
*/ ytitle(Estimated Profit Cycles) legend(off) saving(C:\LakesPaper\Figures\profBCkrnlER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328)/*
*/ ytitle(Quantitity and Estimated Profit Cycles) legend(off) saving(C:\LakesPaper\Figures\profBCQBCkrnlER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

drop pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Lakesopen* Deviation

/************ Import Data from Kernel Estimation with Dynamic Adjustment of PCM ********************/
sort t
merge t using "${datain}pcmkrnl_1ER.dta"
drop _merge
summ pcm
gen PCM=pcm /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen

* Extrapolate business cycle from PCM (variable BCpcm)
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
* Plot pcm and its business cycles
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(medium) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) /*
*/ ylabel(-.5(.5).5) ytitle(Estimated PCM Cycles) legend(off) saving(C:\LakesPaper\Figures\pcmBCkrnl_1ER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

*Plot PCMs Booms Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ xtitle(Q) ytitle(Estimated PCM Booms and Recessions) legend(off) saving(C:\LakesPaper\Figures\pcmu_dBCQBCkrnl_1ER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /* 
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328)/*
*/ ylabel(-.5(.5).5) ytitle(Quantitity and Estimated PCM Cycles) legend(off) saving(C:\LakesPaper\Figures\pcmBCQBCkrnl_1ER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

twoway scatter pcm t, ms(i) c(l) lpattern(l) sort cmissing(n)||scatter Deviations t, ms(+) cmissing(n)||scatter Lakesopen t, ms(+) cmissing(n) /*
*/ xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(Estimated PCM) legend(off) saving(C:\LakesPaper\Figures\pcmkrnl_1ER.eps, replace) lpattern(l -) color(black black)/*
*/ scheme(s1manual)
gen profit=pcm*Q/10000
replace Lakesopen=4*Lakesopen
twoway scatter profit t, ms(i) c(l) lpattern(l) sort cmissing(n)||scatter Deviations t, ms(+) cmissing(n)||scatter Lakesopen t, ms(+) cmissing(n) /*
*/ xlabel(0(52)328) ytitle(Estimated Profit) legend(off) saving(C:\LakesPaper\Figures\profkrnl_1ER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

* Extrapolate business cycle from PROF (variable BCprofit)
gen PROF=profit /* Variables used to determine the business cycles */

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit
* Plot Estimated Profit and its business cycles
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /* 
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328) /*
*/ ytitle(Estimated Profit Cycles) legend(off) saving(C:\LakesPaper\Figures\profBCkrnl_1ER.eps, replace) lpattern(l -) color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(+) cmissing(n) ||scatter Lakesopen t, ms(+) cmissing(n) xlabel(0(52)328)/*
*/ ytitle(Quantitity and Estimated Profit Cycles) legend(off) saving(C:\LakesPaper\Figures\profBCQBCkrnl_1ER.eps, replace) lpattern(l -) /*
*/ color(black black) scheme(s1manual)

drop pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Lakesopen* Deviations

* Save file to be used in Matlab for Kernel estimation
drop PRhat
arima PR GF_1 GFT_1 N_1 L_1 NWO_1 NWC_1 Big1_1 Big2_1 BigQ_1 Small1_1 ER_1 ER1_1, ar(1)
predict PRhat 
replace PRhat=F.PRhat
keep t PRhat q q_1 gr L NWO NWC grstar MNCY S1-S4
drop if PRhat==.|grstar==.
saveold "${dataout}railKernelER.dta", replace


/*
sort t
gen const=1
drop if dgp1N0N_1==.
keep PRop t const q_1 N H_1 SSD_1 dgp1N0N_1 L_1
saveold "${dataout}railR.dta", replace


*Table I of Porter (1985) Conditional Probabilities on Colluding previous period 
probit PO L_1 Q_1 H_1 SSD_1 if PO[_n-1]==1
probit PR L_1 Q_1 H_1 SSD_1 if PR[_n-1]==1
probit PO LC_1 Q_1 H_1 SSD_1 lgrlc NWO_1 NWC_1 dgp0NC_1 dgp1N0N_1 if PO[_n-1]==1
probit PR LC_1 Q_1 H_1 SSD_1 lgrlc NWO_1 NWC_1 dgp0NC_1 dgp1N0N_1 if PR[_n-1]==1

*Unconditional probabilities
probit PO L_1 q_1 H_1 SSD_1
predict POhat
replace POhat=POhat[_n+1] if POhat[_n]==.
sort t
keep POhat
saveold "${dataout}wgth0.dta", replace

use "${datain}rail.dta", clear
probit PR L_1 q_1 H_1 SSD_1
predict PRhat
replace PRhat=PRhat[_n+1] if PRhat[_n]==.
sort t
keep PRhat
saveold "${dataout}wgth1.dta", replace

use "${datain}rail.dta", clear
probit ponew L_1 Q_1 H_1 SSD_1
probit PO LC_1 Q_1 H_1 SSD_1 lgrlc NWO_1 NWC_1 dgp0NC_1 dgp1N0N_1 
probit ponew LC_1 Q_1 H_1 SSD_1 lgrlc NWO_1 NWC_1 dgp0NC_1 dgp1N0N_1 
