macro drop _all

global T="A"
global table "QJER1_Pov_Base"

global controls1 "lSpoptotal lSpoprural lSpopurban Slat Slon lSrichshare lSpoorshare"
global controls21 "lSpoptotal lSgdpnrg lSarea lSararea Slat Slon lSoil lSpoprural lSpopurban lSservices lSagr lSexports lSimports lSmanuf lShcfa lSgovexp lSgrosscapform lSrichshare lSpoorshare"
global controls22 "lSpoptotal2 lSgdpnrg2 lSarea2 lSararea2 Slat2 Slon2 lSoil2 lSpoprural2 lSpopurban2 lSservices2 lSagr2 lSexports2 lSimports2 lSmanuf2 lShcfa2 lSgovexp2 lSgrosscapform2 lSrichshare2 lSpoorshare2"


if "$T"=="A" | "$T"=="C" {

cap log close
log using Share.log, replace

pause off

clear
do nasm_setup

global povline=2.5*365.25
global thresh0=1e-3*365.25
global thresh1=${povline}

by isocode, so: egen surveycount=count(lrgdpchsurveys)
ta cname if surveycount==0 & region!="hoecd" & region!="hnoecd"  & year==2010 [aw=popWB], sort

noisily {
gen sigma=sqrt(2)*invnormal((gini/100+1)/2)
gen true_survey=(lrgdpchsurveys!=.)

cap drop *_ip*

so isocode year
by isocode: ipolate lrgdpchWB year, gen(lrgdpchWB_ip) epolate
by isocode: ipolate lrgdpchWBc year, gen(lrgdpchWBc_ip) epolate
foreach v of varlist lSpoprural lSpoptotal lSpopurban lSservices lSagr lSexports lSimports lSmanuf lShcfa lSgovexp lSgrosscapform {
by isocode: ipolate `v' year, gen(`v'_ip) epolate
}
by isocode: ipolate lrgdpchsurveys year, gen(lrgdpchsurveys_ip) epolate
by isocode: ipolate sigma year, gen(sigma_ip0) epolate
clonevar sigma_ip=sigma_ip0
by isocode: ipolate sigma year, gen(sigma_ip1)
clonevar sigma_ip2=sigma_ip1
so isocode year
by isocode: replace lrgdpchsurveys_ip=lrgdpchsurveys_ip[_n-1]+lrgdpchWB-lrgdpchWB[_n-1] if lrgdpchsurveys_ip==. & lrgdpchsurveys_ip[_n-1]!=. & lrgdpchWB!=. & lrgdpchWB[_n-1]!=.
by isocode: replace sigma_ip=sigma_ip[_n-1] if sigma_ip==. & sigma_ip[_n-1]!=.
by isocode: replace sigma_ip1=sigma_ip1[_n-1] if sigma_ip1==. & sigma_ip1[_n-1]!=.
gsort isocode -year
by isocode: replace lrgdpchsurveys_ip=lrgdpchsurveys_ip[_n-1]+lrgdpchWB-lrgdpchWB[_n-1] if lrgdpchsurveys_ip==. & lrgdpchsurveys_ip[_n-1]!=. & lrgdpchWB!=. & lrgdpchWB[_n-1]!=.
by isocode: replace sigma_ip=sigma_ip[_n-1] if sigma_ip==. & sigma_ip[_n-1]!=.
by isocode: replace sigma_ip2=sigma_ip2[_n-1] if sigma_ip2==. & sigma_ip2[_n-1]!=.

clonevar sigma_ip4=sigma_ip
replace sigma_ip4=min(sigma_ip4,sigma_ip2) if sigma_ip4!=sigma_ip2 & sigma_ip4!=. & sigma_ip2!=.
replace sigma_ip4=max(sigma_ip4,sigma_ip1) if sigma_ip4!=sigma_ip1 & sigma_ip1!=. & sigma_ip4!=.
rename sigma_ip sigma_ip5

cap drop sigma_ip
gen sigma_ip=sigma_ip5

su sigma
replace sigma_ip=max(min(sigma_ip, r(max)) ,r(min)) if sigma_ip!=.


preserve
keep region year
duplicates drop
rename region cname
save regionstub, replace
restore
append using regionstub

preserve
keep year
duplicates drop
gen cname="world"
save regionstub, replace
restore
append using regionstub

cap drop SSA Asia LA PC
gen SSA=(region=="ssa")
gen Asia=(region=="ea" | region=="sa" | region=="mena")
gen LA=(region=="la")
gen PC=(region=="eeu" | region=="exsoviet")
}


save NASM_base2, replace




global B=120
global col=1

global povline=1.25*365.25
global thresh0=1e-3*365.25
global thresh1=${povline}

*CR (2010)
noisily {
global title1_${col}="Survey Weight = 1"
global title2_${col}="(CR 2010)"

use NASM_base2, clear

gen weight_lrgdpchWB=0
gen weight_lrgdpchsurveys=1
gen heta=0

gen lrgdpchfit1=weight_lrgdpchWB*lrgdpchWB+weight_lrgdpchsurveys*lrgdpchsurveys_ip+heta
gen rgdpchfit1=exp(lrgdpchfit1)

gen mufit1=lrgdpchfit1-(1/2)*sigma_ip^2
gen POVRT1=normal((ln(${thresh1})-mufit1)/sigma_ip)-normal((ln(${thresh0})-mufit1)/sigma_ip)
gen PR20151=.
gen DP1_2010=.
gen DP1_2015=.
gen GR2010=.
*replace POVRT1=0 if (region=="hoecd" | region=="hnoecd")
cap drop mufit1 lrgdpchfit1 weight_* heta*

forvalues y=1992/2010 {
su POVRT1 if year==`y' & isocode!="" [aw=popWB]
global POVRT1_world_`y'=r(mean)
replace POVRT1=${POVRT1_world_`y'} if cname=="world" & year==`y'
replace popWB=r(sum_w) if cname=="world" & year==`y'
su rgdpchfit1 if year==`y' & isocode!="" [aw=popWB]
replace rgdpchfit1=r(mean) if cname=="world" & year==`y'
foreach r in ea sa la ssa mena eeu exsoviet {
su POVRT1 if region=="`r'" & year==`y' [aw=popWB]
global POVRT1_`r'_`y'=r(mean)
replace POVRT1=${POVRT1_`r'_`y'} if cname=="`r'" & year==`y'
replace popWB=r(sum_w) if cname=="`r'" & year==`y'
su rgdpchfit1 if region=="`r'" & year==`y' [aw=popWB]
replace rgdpchfit1=r(mean) if cname=="`r'" & year==`y'
}
}

foreach r in world ea sa la ssa mena eeu exsoviet {
qui su rgdpchfit1 if year==1992 & cname=="`r'"
global rgdpchfit1_1992=r(mean)
qui su rgdpchfit1 if year==2010 & cname=="`r'"
global rgdpchfit1_2010=r(mean)
global GR2010=${rgdpchfit1_2010}/${rgdpchfit1_1992}-1
replace GR2010=${GR2010} if cname=="`r'"
global DP1_2010=${POVRT1_`r'_2010}/${POVRT1_`r'_1992}
global M=(${POVRT1_`r'_2010}-${POVRT1_`r'_2000})/10
global POVRT1_`r'_2015=${POVRT1_`r'_2010}+5*${M}
global DP1_2015=${POVRT1_`r'_2015}/${POVRT1_`r'_1992}
replace DP1_2010=${DP1_2010}  if cname=="`r'"
replace DP1_2015=${DP1_2015}  if cname=="`r'"
replace PR20151=${POVRT1_`r'_2015}  if cname=="`r'"
}


foreach var in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 GR2010 {
egen mean_`var'=rowmean(`var'*)
egen ub_`var'=rowpctile(`var'*), p(95)
egen lb_`var'=rowpctile(`var'*), p(5)
drop `var'*
}

foreach r in world ea sa la ssa mena eeu exsoviet {
forvalues y=1992/2010 {
foreach m in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 GR2010 {
foreach s in mean ub lb {
cap qui su `s'_`m' if cname=="`r'" & year==`y'
cap global `m'_`s'_`r'_`y'_${col}=r(mean)
}
}
}
}

so cname year
noi list cname year popWB *rgdpchfit1 *POVRT1 if isocode==""

preserve
keep cname year popWB mean_* ub_* lb_*
so cname year
foreach v of varlist mean_* ub_* lb_* {
rename `v' `v'_${col}
lab var `v'_${col} "`="${title1_${col}}"+" "+"${title2_${col}}"'"
}
save NASM_output_${col}, replace
so cname year
save NASM_output_${table}, replace
restore


global col=1+${col}

pause
}


*PSiM (2009)
noisily {

global title1_${col}="GDP Weight = 1"
global title2_${col}="(PSiM 2009)"

use NASM_base2, clear

gen weight_lrgdpchWB=1
gen weight_lrgdpchsurveys=0
gen heta=0

gen lrgdpchfit1=weight_lrgdpchWB*lrgdpchWB+weight_lrgdpchsurveys*lrgdpchsurveys_ip+heta

gen rgdpchfit1=exp(lrgdpchfit1)

gen mufit1=lrgdpchfit1-(1/2)*sigma_ip^2
gen POVRT1=normal((ln(${thresh1})-mufit1)/sigma_ip)-normal((ln(${thresh0})-mufit1)/sigma_ip)
gen PR20151=.
gen DP1_2010=.
gen DP1_2015=.
gen GR2010=.
*replace POVRT1=0 if (region=="hoecd" | region=="hnoecd")
cap drop mufit1 lrgdpchfit1 weight_* heta*

forvalues y=1992/2010 {
su POVRT1 if year==`y' & isocode!="" [aw=popWB]
global POVRT1_world_`y'=r(mean)
replace POVRT1=${POVRT1_world_`y'} if cname=="world" & year==`y'
replace popWB=r(sum_w) if cname=="world" & year==`y'
su rgdpchfit1 if year==`y' & isocode!="" [aw=popWB]
replace rgdpchfit1=r(mean) if cname=="world" & year==`y'
foreach r in ea sa la ssa mena eeu exsoviet {
su POVRT1 if region=="`r'" & year==`y' [aw=popWB]
global POVRT1_`r'_`y'=r(mean)
replace POVRT1=${POVRT1_`r'_`y'} if cname=="`r'" & year==`y'
replace popWB=r(sum_w) if cname=="`r'" & year==`y'
su rgdpchfit1 if region=="`r'" & year==`y' [aw=popWB]
replace rgdpchfit1=r(mean) if cname=="`r'" & year==`y'
}
}

foreach r in world ea sa la ssa mena eeu exsoviet {
qui su rgdpchfit1 if year==1992 & cname=="`r'"
global rgdpchfit1_1992=r(mean)
qui su rgdpchfit1 if year==2010 & cname=="`r'"
global rgdpchfit1_2010=r(mean)
global GR2010=${rgdpchfit1_2010}/${rgdpchfit1_1992}-1
replace GR2010=${GR2010} if cname=="`r'"
global DP1_2010=${POVRT1_`r'_2010}/${POVRT1_`r'_1992}
global M=(${POVRT1_`r'_2010}-${POVRT1_`r'_2000})/10
global POVRT1_`r'_2015=${POVRT1_`r'_2010}+5*${M}
global DP1_2015=${POVRT1_`r'_2015}/${POVRT1_`r'_1992}
replace DP1_2010=${DP1_2010}  if cname=="`r'"
replace DP1_2015=${DP1_2015}  if cname=="`r'"
replace PR20151=${POVRT1_`r'_2015}  if cname=="`r'"
}


foreach var in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 GR2010 {
egen mean_`var'=rowmean(`var'*)
egen ub_`var'=rowpctile(`var'*), p(95)
egen lb_`var'=rowpctile(`var'*), p(5)
drop `var'*
}

foreach r in world ea sa la ssa mena eeu exsoviet {
forvalues y=1992/2010 {
foreach m in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 GR2010 {
foreach s in mean ub lb {
cap qui su `s'_`m' if cname=="`r'" & year==`y'
cap global `m'_`s'_`r'_`y'_${col}=r(mean)
}
}
}
}

so cname year
noi list cname year popWB *rgdpchfit1 *POVRT1 if isocode==""

preserve
keep cname year popWB mean_* ub_* lb_*
so cname year
foreach v of varlist mean_* ub_* lb_* {
rename `v' `v'_${col}
lab var `v'_${col} "`="${title1_${col}}"+" "+"${title2_${col}}"'"
}
save NASM_output_${col}, replace
so cname year
merge using NASM_output_${table}
ta _me
drop _me
so cname year
save NASM_output_${table}, replace
restore

global col=1+${col}

pause
}

global povline=2.5*365.25
global thresh0=1e-3*365.25
global thresh1=${povline}

*CR (2010) $2
noisily {
global title1_${col}="Survey Weight = 1"
global title2_${col}="(CR 2010)"

use NASM_base2, clear

gen weight_lrgdpchWB=0
gen weight_lrgdpchsurveys=1
gen heta=0

gen lrgdpchfit1=weight_lrgdpchWB*lrgdpchWB+weight_lrgdpchsurveys*lrgdpchsurveys_ip+heta
gen rgdpchfit1=exp(lrgdpchfit1)

gen mufit1=lrgdpchfit1-(1/2)*sigma_ip^2
gen POVRT1=normal((ln(${thresh1})-mufit1)/sigma_ip)-normal((ln(${thresh0})-mufit1)/sigma_ip)
gen PR20151=.
gen DP1_2010=.
gen DP1_2015=.
gen GR2010=.
*replace POVRT1=0 if (region=="hoecd" | region=="hnoecd")
cap drop mufit1 lrgdpchfit1 weight_* heta*

forvalues y=1992/2010 {
su POVRT1 if year==`y' & isocode!="" [aw=popWB]
global POVRT1_world_`y'=r(mean)
replace POVRT1=${POVRT1_world_`y'} if cname=="world" & year==`y'
replace popWB=r(sum_w) if cname=="world" & year==`y'
su rgdpchfit1 if year==`y' & isocode!="" [aw=popWB]
replace rgdpchfit1=r(mean) if cname=="world" & year==`y'
foreach r in ea sa la ssa mena eeu exsoviet {
su POVRT1 if region=="`r'" & year==`y' [aw=popWB]
global POVRT1_`r'_`y'=r(mean)
replace POVRT1=${POVRT1_`r'_`y'} if cname=="`r'" & year==`y'
replace popWB=r(sum_w) if cname=="`r'" & year==`y'
su rgdpchfit1 if region=="`r'" & year==`y' [aw=popWB]
replace rgdpchfit1=r(mean) if cname=="`r'" & year==`y'
}
}

foreach r in world ea sa la ssa mena eeu exsoviet {
qui su rgdpchfit1 if year==1992 & cname=="`r'"
global rgdpchfit1_1992=r(mean)
qui su rgdpchfit1 if year==2010 & cname=="`r'"
global rgdpchfit1_2010=r(mean)
global GR2010=${rgdpchfit1_2010}/${rgdpchfit1_1992}-1
replace GR2010=${GR2010} if cname=="`r'"
global DP1_2010=${POVRT1_`r'_2010}/${POVRT1_`r'_1992}
global M=(${POVRT1_`r'_2010}-${POVRT1_`r'_2000})/10
global POVRT1_`r'_2015=${POVRT1_`r'_2010}+5*${M}
global DP1_2015=${POVRT1_`r'_2015}/${POVRT1_`r'_1992}
replace DP1_2010=${DP1_2010}  if cname=="`r'"
replace DP1_2015=${DP1_2015}  if cname=="`r'"
replace PR20151=${POVRT1_`r'_2015}  if cname=="`r'"
}


foreach var in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 GR2010 {
egen mean_`var'=rowmean(`var'*)
egen ub_`var'=rowpctile(`var'*), p(95)
egen lb_`var'=rowpctile(`var'*), p(5)
drop `var'*
}

foreach r in world ea sa la ssa mena eeu exsoviet {
forvalues y=1992/2010 {
foreach m in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 GR2010 {
foreach s in mean ub lb {
cap qui su `s'_`m' if cname=="`r'" & year==`y'
cap global `m'_`s'_`r'_`y'_${col}=r(mean)
}
}
}
}

so cname year
noi list cname year popWB *rgdpchfit1 *POVRT1 if isocode==""

preserve
keep cname year popWB mean_* ub_* lb_*
so cname year
foreach v of varlist mean_* ub_* lb_* {
rename `v' `v'_${col}
lab var `v'_${col} "`="${title1_${col}}"+" "+"${title2_${col}}"'"
}
save NASM_output_${col}, replace
so cname year
save NASM_output_${table}, replace
restore


global col=1+${col}

pause
}


*PSiM (2009) $2
noisily {

global title1_${col}="GDP Weight = 1"
global title2_${col}="(PSiM 2009)"

use NASM_base2, clear

gen weight_lrgdpchWB=1
gen weight_lrgdpchsurveys=0
gen heta=0

gen lrgdpchfit1=weight_lrgdpchWB*lrgdpchWB+weight_lrgdpchsurveys*lrgdpchsurveys_ip+heta

gen rgdpchfit1=exp(lrgdpchfit1)

gen mufit1=lrgdpchfit1-(1/2)*sigma_ip^2
gen POVRT1=normal((ln(${thresh1})-mufit1)/sigma_ip)-normal((ln(${thresh0})-mufit1)/sigma_ip)
gen PR20151=.
gen DP1_2010=.
gen DP1_2015=.
gen GR2010=.
*replace POVRT1=0 if (region=="hoecd" | region=="hnoecd")
cap drop mufit1 lrgdpchfit1 weight_* heta*

forvalues y=1992/2010 {
su POVRT1 if year==`y' & isocode!="" [aw=popWB]
global POVRT1_world_`y'=r(mean)
replace POVRT1=${POVRT1_world_`y'} if cname=="world" & year==`y'
replace popWB=r(sum_w) if cname=="world" & year==`y'
su rgdpchfit1 if year==`y' & isocode!="" [aw=popWB]
replace rgdpchfit1=r(mean) if cname=="world" & year==`y'
foreach r in ea sa la ssa mena eeu exsoviet {
su POVRT1 if region=="`r'" & year==`y' [aw=popWB]
global POVRT1_`r'_`y'=r(mean)
replace POVRT1=${POVRT1_`r'_`y'} if cname=="`r'" & year==`y'
replace popWB=r(sum_w) if cname=="`r'" & year==`y'
su rgdpchfit1 if region=="`r'" & year==`y' [aw=popWB]
replace rgdpchfit1=r(mean) if cname=="`r'" & year==`y'
}
}

foreach r in world ea sa la ssa mena eeu exsoviet {
qui su rgdpchfit1 if year==1992 & cname=="`r'"
global rgdpchfit1_1992=r(mean)
qui su rgdpchfit1 if year==2010 & cname=="`r'"
global rgdpchfit1_2010=r(mean)
global GR2010=${rgdpchfit1_2010}/${rgdpchfit1_1992}-1
replace GR2010=${GR2010} if cname=="`r'"
global DP1_2010=${POVRT1_`r'_2010}/${POVRT1_`r'_1992}
global M=(${POVRT1_`r'_2010}-${POVRT1_`r'_2000})/10
global POVRT1_`r'_2015=${POVRT1_`r'_2010}+5*${M}
global DP1_2015=${POVRT1_`r'_2015}/${POVRT1_`r'_1992}
replace DP1_2010=${DP1_2010}  if cname=="`r'"
replace DP1_2015=${DP1_2015}  if cname=="`r'"
replace PR20151=${POVRT1_`r'_2015}  if cname=="`r'"
}


foreach var in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 GR2010 {
egen mean_`var'=rowmean(`var'*)
egen ub_`var'=rowpctile(`var'*), p(95)
egen lb_`var'=rowpctile(`var'*), p(5)
drop `var'*
}

foreach r in world ea sa la ssa mena eeu exsoviet {
forvalues y=1992/2010 {
foreach m in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 GR2010 {
foreach s in mean ub lb {
cap qui su `s'_`m' if cname=="`r'" & year==`y'
cap global `m'_`s'_`r'_`y'_${col}=r(mean)
}
}
}
}

so cname year
noi list cname year popWB *rgdpchfit1 *POVRT1 if isocode==""

preserve
keep cname year popWB mean_* ub_* lb_*
so cname year
foreach v of varlist mean_* ub_* lb_* {
rename `v' `v'_${col}
lab var `v'_${col} "`="${title1_${col}}"+" "+"${title2_${col}}"'"
}
save NASM_output_${col}, replace
so cname year
merge using NASM_output_${table}
ta _me
drop _me
so cname year
save NASM_output_${table}, replace
restore

global col=1+${col}

pause
}


global col1=${col}
global col=${col}-1
log close

/* End of Computation */
}


if "$T"=="A" | "$T"=="T" {



*Here we reformat all the statistics we have collected
forvalues c=1/$col {
foreach m in POVRT1 rgdpchfit1 DP1_2010 DP1_2015 PR20151 DP1S_2010 DP1S_2015 PRS20151 GR2010 {
foreach s in mean ub lb {
foreach r in world ea sa la ssa mena eeu exsoviet {
forvalues y=1992/2010 {
global r `r'
global c `c'
global s `s'
global m `m'
global y `y'
cap global macro "${m}_${s}_${r}_${y}_${c}"
cap global ${macro}=substr("${${macro}}",1,strpos("${${macro}}",".")+3)
if "$m"=="rgdpchfit1" {
cap global ${macro}=substr("${${macro}}",1,strpos("${${macro}}",".")-1)
}
if "${s}"=="mean" {
cap global ${macro}="{ ${${macro}}}"
}
if "${s}"=="ub" | "${s}"=="lb"  {
cap global ${macro}=cond("${${macro}}"!="","{ (${${macro}})}","")
}

}
}
}
}
}

*Adjustment to flip rows and columns*
global row=${col}
global yearlist "1992 2005 2006 2007 2008 2009 2010"
global col=wordcount("$yearlist")+1
global colm3=wordcount("$yearlist")
global col1=1+${col}
*End of Adjustment*

*Here we construct the table itself

global table1 ${table}
global m POVRT1
global r world

global T_world "Developing World"
global T_ea "East Asia"
global T_sa "South Asia"
global T_la "Latin America"
global T_ssa "Sub-Saharan Africa"
global T_mena "Middle East - North Africa"
global T_eeu "Eastern Europe"
global T_exsoviet "Former Soviet Union"

global table ${table1}_${world}

quietly {
cap log close
log using l${table}.txt, replace

noi di "\documentclass[10pt]{report}"
noi di "\pagestyle{plain}"
noi di "\setlength{\topmargin}{-.25in}"
noi di "\setlength{\textheight}{8.5in}"
noi di "\setlength{\oddsidemargin}{0in}"
noi di "\setlength{\evensidemargin}{0in}"
noi di "\setlength{\textwidth}{5.5in}"
noi di "\usepackage{geometry}"
noi di "\usepackage{scalefnt}"
noi di "\geometry{right=1in,left=0.5in,top=1in,bottom=1in}"
noi di "\begin{document}"
noi di "\begin{center}"
noi di "\setlength{\baselineskip}{14pt}"


#delimit ;
global stringc=""; forvalues i=1/$col {; global stringc="$stringc"+"c"; };
#delimit cr

#delimit;
global stringnum=""; forvalues i=1/$col {; global stringnum="$stringnum"+"& (`i') "; };
#delimit cr

#delimit;
global stringsp=""; forvalues i=1/$col {; global stringsp="$stringsp"+"& "; };
#delimit cr

#delimit;
global stringspm3=""; forvalues i=1/$colm3 {; global stringspm3="$stringspm3"+"& "; };
#delimit cr

#delimit;
global stringyears=""; forvalues i=1/$colm3 {; global stringyears="$stringyears"+"& `=word("${yearlist}",`i')'"; };
#delimit cr

noi di "\begin{tabular}{|l|$stringc|}"
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{} \\ [-.15in]"
noi di "\multicolumn{$col1}{|c|}{\bf Developing World Poverty Estimates: Baseline} \\ [.04in]"
noi di "\hline"
noi di "$stringnum \\ [.04in]"
noi di "\hline"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringyears  & Ratio \\ [.04in]"     
noi di "$stringspm3  & 2010-1992 \\ [.04in]"  
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "\hline"

forvalues c=1/$row {
global c=`c'

foreach S in mean ub lb {
global S `S'
global string${S}=""
foreach y in $yearlist {
global y=`y'
global string${S}="${string${S}}"+"& ${${m}_${S}_${r}_${y}_${c}} "
}
*global string${S}="${string${S}}"+"& ${PR20151_${S}_${r}_2010_${c}} "
global string${S}="${string${S}}"+"& ${DP1_2010_${S}_${r}_2010_${c}} "
*global string${S}="${string${S}}"+"& ${DP1_2015_${S}_${r}_2010_${c}} "
}

global S blank
global string${S}=""
foreach y in $yearlist {
global y=`y'
global string${S}="${string${S}}"+"& "
}
global string${S}="${string${S}}"+"& "
global string${S}="${string${S}}"+"& "
global string${S}="${string${S}}"+"& "


if strpos("${title1_${c}}","Survey Weight = 1")==0 {
noi di "\hline"
}

if strpos("${title1_${c}}","Survey Weight = 1")!=0 {
noi di "\hline\hline"
}

if `c'==1 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Panel I: 1 Dollar-a-Day Poverty Rates} \\ [.04in]"
noi di "\hline\hline\hline"
}
if `c'==3 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Panel II: 2 Dollar-a-Day Poverty Rates} \\ [.04in]"
noi di "\hline\hline\hline"
}
if strpos("${title2_${c}}","OECD")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Robustness to Underestimation of Inequality in the Surveys} \\ [.04in]"
noi di "\hline\hline\hline"
}

noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "(${c}) ${title1_${c}}  ${stringmean} \\"
if strpos("${title1_${c}}"," = 1")==0 {
noi di " ${title2_${c}}  ${stringlb} \\"
noi di "  		         ${stringub} \\"
}
else {
noi di " ${title2_${c}}  ${stringspm3} \\"
}


}

#delimit;
global stringyes=""; forvalues i=1/$col {; global stringyes="$stringyes"+"& Yes"; };
#delimit cr

noi di "\hline"

noi di "\hline"
noi di "\end{tabular}"
noi di "\end{center}"

noi di "\end{document}"
log close
}

qui shell perl -s tablemod.pl -tablenew="${table}" -table="l${table}"
*shellout using "${table}.tex"
qui !texify -p -c -b --run-viewer ${table}.tex
/*End of Table Construction*/





*Here we construct the regional table

global m POVRT1

global table1 ${table}_regions
global col=8
global col1=9
global colm2=7

quietly {
cap log close
log using l${table1}.txt, replace

noi di "\documentclass[10pt]{report}"
noi di "\pagestyle{plain}"
noi di "\setlength{\topmargin}{-.25in}"
noi di "\setlength{\textheight}{8.5in}"
noi di "\setlength{\oddsidemargin}{0in}"
noi di "\setlength{\evensidemargin}{0in}"
noi di "\setlength{\textwidth}{5.5in}"
noi di "\usepackage{geometry}"
noi di "\usepackage{scalefnt}"
noi di "\geometry{right=1in,left=0.5in,top=1in,bottom=1in}"
noi di "\begin{document}"
noi di "\begin{center}"
noi di "\setlength{\baselineskip}{14pt}"


#delimit ;
global stringc=""; forvalues i=1/$col {; global stringc="$stringc"+"c"; };
#delimit cr

#delimit;
global stringnum="& "; forvalues i=1/$colm2 {; global stringnum="$stringnum"+"& (`i') "; };
#delimit cr

#delimit;
global stringsp=""; forvalues i=1/$col {; global stringsp="$stringsp"+"& "; };
#delimit cr


noi di "\begin{tabular}{|l|$stringc|}"
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{} \\ [-.15in]"
noi di "\multicolumn{$col1}{|c|}{\bf Regional Poverty Estimates: Baseline} \\ [.04in]"
noi di "\hline"
noi di "$stringnum \\ [.04in]"
noi di "\hline"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "& & Dev.  & East & South & Lat.& SSA & MENA & Fmr \\ [.04in]"     
noi di "& & World & Asia & Asia  & Am. &     &      & USSR \\ [.04in]"  
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "\hline"

forvalues c=1/$row {
global c=`c'

global string1992="& Poverty 1992"
global string2010="& Poverty 2010"
global string2015="& Proj. Share 2015"
global stringDP1_2010="& Ratio 2010/1992"
global stringDP1_2010_ub="& Ratio 2010/1992 UB"
global stringDP1_2010_lb="& Ratio 2010/1992 LB"
global string2015S="& Ext. Proj. Share 2015"
global stringDP1S_2010="& Extreme Ratio 2010/1992"
global stringDP1S_2010_lb="& Extreme Ratio 2010/1992 LB"

foreach r in world ea sa la ssa mena exsoviet {
global r "`r'"
global string1992="${string1992}"+"& ${${m}_mean_${r}_1992_${c}} "
global string2010="${string2010}"+"& ${${m}_mean_${r}_2010_${c}} "
global string2015="${string2015}"+"& ${PR20151_mean_${r}_2010_${c}} "
global stringDP1_2010="${stringDP1_2010}"+"& ${DP1_2010_mean_${r}_2010_${c}} "
global stringDP1_2010_ub="${stringDP1_2010_ub}"+"& ${DP1_2010_ub_${r}_2010_${c}} "
global stringDP1_2010_lb="${stringDP1_2010_lb}"+"& ${DP1_2010_lb_${r}_2010_${c}} "
global string2015S="${string2015S}"+"& ${PRS20151_mean_${r}_2010_${c}} "
global stringDP1S_2010="${stringDP1S_2010}"+"& ${DP1S_2010_mean_${r}_2010_${c}} "
global stringDP1S_2010_lb="${stringDP1S_2010_lb}"+"& ${DP1S_2010_lb_${r}_2010_${c}} "
}



if strpos("${title1_${c}}","Survey Weight = 1")==0 {
noi di "\hline"
}

if strpos("${title1_${c}}","Survey Weight = 1")!=0 {
noi di "\hline\hline"
}

if strpos("${title2_${c}}","GDP + Error")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Robustness to Different Normalizations of Scale and Magnitude of Weights} \\ [.04in]"
noi di "\hline\hline\hline"
}
if strpos("${title1_${c}}","1992")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Exploration of Sources of Difference between Surveys and Lights-Based Proxy} \\ [.04in]"
noi di "\hline\hline\hline"
}
if strpos("${title2_${c}}","OECD")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Robustness to Underestimation of Inequality in the Surveys} \\ [.04in]"
noi di "\hline\hline\hline"
}

noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "(${c}) ${title1_${c}}  ${string1992} \\"
noi di " ${title2_${c}}  ${string2010} \\"
*noi di "  		         ${string2015} \\"
noi di "  		         ${stringDP1_2010} \\"
if strpos("${title1_${c}}"," = 1")==0 {
noi di "  		         ${stringDP1_2010_ub} \\"
}

}


#delimit;
global stringyes=""; forvalues i=1/$col {; global stringyes="$stringyes"+"& Yes"; };
#delimit cr

noi di "\hline"

noi di "\hline"
noi di "\end{tabular}"
noi di "\end{center}"

noi di "\end{document}"
log close
}

qui shell perl -s tablemod.pl -tablenew="${table1}" -table="l${table1}"
*shellout using "${table}.tex"
qui !texify -p -c -b --run-viewer ${table1}.tex
/*End of Table Construction*/


*Here we construct the GDP table

global col=wordcount("$yearlist")+1
global colm1=${col}-1
global col1=1+${col}
*End of Adjustment*

global m rgdpchfit1

global T_world "Developing World"
global T_ea "East Asia"
global T_sa "South Asia"
global T_la "Latin America"
global T_ssa "Sub-Saharan Africa"
global T_mena "Middle East - North Africa"
global T_eeu "Eastern Europe"
global T_exsoviet "Former Soviet Union"

global table1 ${table}_gdp
global r "world"

quietly {
cap log close
log using l${table1}.txt, replace

noi di "\documentclass[10pt]{report}"
noi di "\pagestyle{plain}"
noi di "\setlength{\topmargin}{-.25in}"
noi di "\setlength{\textheight}{8.5in}"
noi di "\setlength{\oddsidemargin}{0in}"
noi di "\setlength{\evensidemargin}{0in}"
noi di "\setlength{\textwidth}{5.5in}"
noi di "\usepackage{geometry}"
noi di "\usepackage{scalefnt}"
noi di "\geometry{right=1in,left=0.5in,top=1in,bottom=1in}"
noi di "\begin{document}"
noi di "\begin{center}"
noi di "\setlength{\baselineskip}{14pt}"


#delimit ;
global stringc=""; forvalues i=1/$col {; global stringc="$stringc"+"c"; };
#delimit cr

#delimit;
global stringnum=""; forvalues i=1/$col {; global stringnum="$stringnum"+"& (`i') "; };
#delimit cr

#delimit;
global stringsp=""; forvalues i=1/$col {; global stringsp="$stringsp"+"& "; };
#delimit cr

#delimit;
global stringspm1=""; forvalues i=1/$colm1 {; global stringspm1="$stringspm1"+"& "; };
#delimit cr

#delimit;
global stringyears=""; forvalues i=1/$colm1 {; global stringyears="$stringyears"+"& `=word("${yearlist}",`i')'"; };
#delimit cr

noi di "\begin{tabular}{|l|$stringc|}"
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{} \\ [-.15in]"
noi di "\multicolumn{$col1}{|c|}{\bf Developing World Lights-Based Estimates of True Income} \\ [.04in]"
noi di "\hline"
noi di "$stringnum \\ [.04in]"
noi di "\hline"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringyears & Growth \\ [.04in]"     
noi di "$stringspm1 & 1992-2010 \\ [.04in]"  
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "\hline"

forvalues c=1/$row {
global c=`c'

foreach S in mean ub lb {
global S `S'
global string${S}=""
foreach y in $yearlist {
global y=`y'
global string${S}="${string${S}}"+"& ${${m}_${S}_${r}_${y}_${c}} "
}
global string${S}="${string${S}}"+"& ${GR2010_${S}_${r}_${y}_${c}} "
}

if strpos("${title1_${c}}","Survey Weight = 1")==0 {
noi di "\hline"
}

if strpos("${title1_${c}}","Survey Weight = 1")!=0 {
noi di "\hline\hline"
}

if strpos("${title2_${c}}","GDP + Error")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Robustness to Different Normalizations of Scale and Magnitude of Weights} \\ [.04in]"
noi di "\hline\hline\hline"
}
if strpos("${title1_${c}}","1992")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Exploration of Sources of Difference between Surveys and Lights-Based Proxy} \\ [.04in]"
noi di "\hline\hline\hline"
}
if strpos("${title2_${c}}","OECD")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Robustness to Underestimation of Inequality in the Surveys} \\ [.04in]"
noi di "\hline\hline\hline"
}

noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "(${c}) ${title1_${c}}  ${stringmean} \\"
if strpos("${title1_${c}}"," = 1")==0 {
noi di " ${title2_${c}}  ${stringlb} \\"
noi di "  		         ${stringub} \\"
}

if strpos("${title1_${c}}","GDP Weight = 1")!=0 {
noi di "\hline\hline\hline"
}

}


#delimit;
global stringyes=""; forvalues i=1/$col1 {; global stringyes="$stringyes"+"& Yes"; };
#delimit cr

noi di "\hline"

noi di "\hline"
noi di "\end{tabular}"
noi di "\end{center}"

noi di "\end{document}"
log close
}

qui shell perl -s tablemod.pl -tablenew="${table1}" -table="l${table1}"
*shellout using "${table}.tex"
qui !texify -p -c -b --run-viewer ${table1}.tex
/*End of Table Construction*/



*Here we construct the regional GDP table

global m rgdpchfit1

global table ${table1}_regions_gdp
global col=8
global col1=9
global colm1=7

quietly {
cap log close
log using l${table}.txt, replace

noi di "\documentclass[10pt]{report}"
noi di "\pagestyle{plain}"
noi di "\setlength{\topmargin}{-.25in}"
noi di "\setlength{\textheight}{8.5in}"
noi di "\setlength{\oddsidemargin}{0in}"
noi di "\setlength{\evensidemargin}{0in}"
noi di "\setlength{\textwidth}{5.5in}"
noi di "\usepackage{geometry}"
noi di "\usepackage{scalefnt}"
noi di "\geometry{right=1in,left=0.5in,top=1in,bottom=1in}"
noi di "\begin{document}"
noi di "\begin{center}"
noi di "\setlength{\baselineskip}{14pt}"


#delimit ;
global stringc=""; forvalues i=1/$col {; global stringc="$stringc"+"c"; };
#delimit cr

#delimit;
global stringnum="& "; forvalues i=1/$colm1 {; global stringnum="$stringnum"+"& (`i') "; };
#delimit cr

#delimit;
global stringsp=""; forvalues i=1/$col {; global stringsp="$stringsp"+"& "; };
#delimit cr


noi di "\begin{tabular}{|l|$stringc|}"
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{} \\ [-.15in]"
noi di "\multicolumn{$col1}{|c|}{\bf Regional Lights-Based Estimates of True Income} \\ [.04in]"
noi di "\hline"
noi di "$stringnum \\ [.04in]"
noi di "\hline"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "& & Dev.  & East & South & Lat.& SSA & MENA & Fmr \\ [.04in]"     
noi di "& & World & Asia & Asia  & Am. &     &      & USSR \\ [.04in]"  
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "\hline"

forvalues c=1/$row {
global c=`c'

global string1992="& GDP per capita in 1992"
global string2005="& GDP per capita in 2005"
global string2010="& GDP per capita in 2010"
global stringGR2010="& Growth 1992-2010"
global stringGR2010LB="& Growth 1992-2010, LB"
foreach r in world ea sa la ssa mena exsoviet {
global r "`r'"
global string1992="${string1992}"+"& ${${m}_mean_${r}_1992_${c}} "
*global string2005="${string2005}"+"& ${${m}_mean_${r}_2005_${c}} "
global string2010="${string2010}"+"& ${${m}_mean_${r}_2010_${c}} "
global stringGR2010="${stringGR2010}"+"& ${GR2010_mean_${r}_2010_${c}} "
global stringGR2010LB="${stringGR2010LB}"+"& ${GR2010_lb_${r}_2010_${c}} "
}

if strpos("${title1_${c}}","Survey Weight = 1")==0 {
noi di "\hline"
}

if strpos("${title1_${c}}","Survey Weight = 1")!=0 {
noi di "\hline\hline"
}

if strpos("${title2_${c}}","GDP + Error")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Robustness to Different Normalizations of Scale and Magnitude of Weights} \\ [.04in]"
noi di "\hline\hline\hline"
}
if strpos("${title1_${c}}","1992")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Exploration of Sources of Difference between Surveys and Lights-Based Proxy} \\ [.04in]"
noi di "\hline\hline\hline"
}
if strpos("${title2_${c}}","OECD")!=0 {
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it Robustness to Underestimation of Inequality in the Surveys} \\ [.04in]"
noi di "\hline\hline\hline"
}

noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "(${c}) ${title1_${c}}   ${string1992} \\"
noi di "${title2_${c}}    ${string2010} \\"
noi di "  		          ${stringGR2010} \\"
if strpos("${title1_${c}}"," = 1")==0 {
noi di "  		          ${stringGR2010LB} \\"
}


}


#delimit;
global stringyes=""; forvalues i=1/$col {; global stringyes="$stringyes"+"& Yes"; };
#delimit cr

noi di "\hline"

noi di "\hline"
noi di "\end{tabular}"
noi di "\end{center}"

noi di "\end{document}"
log close
}

qui shell perl -s tablemod.pl -tablenew="${table}" -table="l${table}"
*shellout using "${table}.tex"
qui !texify -p -c -b --run-viewer ${table}.tex
/*End of Table Construction*/


}


