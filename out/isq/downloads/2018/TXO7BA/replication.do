* This do file will replicate the analysis for Cutrone and Fordham, "Commerce
* and Imagination: The Sources of Concern about International Human Rights in
* the United States Congress." The files include the full speech data as well 
* as subsets used for the analyses individual members and target countries.

* Place the data files in a directory called "C:\replication\"

* Setup for member-day-target data from full speech data file
* See the codebook for full descriptions of each variable in this file
use "C:\replication\speechdata.dta", clear
drop if month==1 & coder==2
drop if month==2 & coder==1
drop if target==.
sort year month day number chamber target
collapse (min) attitude (max) trade aid otherecon force, by(year month day number chamber target)
save "C:\replication\basicdata.dta", replace

* Descriptive statistics on member speeches for Table 2
use "C:\replication\basicdata.dta", clear
gen speeches=1
sort number chamber
collapse (sum) speeches, by(number chamber)
count if chamber==1&speeches>0
count if chamber==2&speeches>0

* Descriptive statistics on target countries for Table 2
use "C:\replication\basicdata.dta", clear
gen speeches=1
gen negspeech=1 if attitude==-1
sort target
collapse (sum)negspeech speeches, by(target)

* Analysis of speeches by House members for Table 3
use "C:\replication\memberspeech.dta", clear
drop if cd==0
xtset idno congress

* Model of all critical speeches
xtnbreg negspeech forbornpct somecoll mdnincm dwnom1 union xint msens, pa corr(ar1) robust nolog
mfx
mfx, at(forbornpct=18.32)
mfx, at(mdnincm=45.71)
mfx, at(somecoll=56.5)
mfx, at(somecoll=34.06)
mfx, at(xint=0.044)
mfx, at(xint=0.018)
mfx, at(msens=0.053)

* Model of speeches mentioning trade sanctions
xtnbreg trdsanction forbornpct somecoll mdnincm dwnom1 union xint msens, pa corr(ar1) robust nolog
mfx
mfx, at(forbornpct=18.32)
mfx, at(mdnincm=45.71)
mfx, at(somecoll=56.5)
mfx, at(somecoll=34.06)
mfx, at(xint=0.044)
mfx, at(xint=0.018)
mfx, at(msens=0.053)

* Models of speeches criticizing allies
xtnbreg negally forbornpct somecoll mdnincm dwnom1 union xint msens, pa corr(ar1) robust nolog
mfx
mfx, at(forbornpct=18.32)
mfx, at(mdnincm=45.71)
mfx, at(dwnom1=0.49)
mfx, at(dwnom1=-0.39)
mfx, at(xint=0.044)
mfx, at(xint=0.018)
mfx, at(msens=0.053)

* Models of speeches criticizing states with which US has had disputes
xtnbreg negdisputes forbornpct somecoll mdnincm dwnom1 union xint msens, pa corr(ar1) robust nolog
mfx
mfx, at(forbornpct=18.32)
mfx, at(mdnincm=45.71)
mfx, at(xint=0.044)
mfx, at(xint=0.018)
mfx, at(msens=0.053)

* Models of House speeches on China for Table 4
xtnbreg chinanegspeech forbornpct somecoll mdnincm dwnom1 union cxint cmsens, pa corr(ar1) robust nolog
mfx
mfx, at(forbornpct=18.32)
mfx, at(cmsens=0.0029)
mfx, at(cxint=0.00075)
mfx, at(cxint=0.00032)

xtnbreg chntrdsanct forbornpct somecoll mdnincm dwnom1 union cxint cmsens, pa corr(ar1) robust nolog
mfx
mfx, at(forbornpct=18.32)
mfx, at(cmsens=0.0029)
mfx, at(cxint=0.00075)
mfx, at(cxint=0.00032)

* Models of Senate speeches not presented in paper
use "C:\replication\memberspeech.dta", clear
keep if cd==0
xtset idno congress

* Model of negative speeches
xtnbreg negspeech forbornpct somecoll mdnincm dwnom1 union xint msens, pa corr(ar1) robust

* Models of speeches calling for trade sanctions
xtnbreg trdsanction forbornpct somecoll mdnincm dwnom1 union xint msens, pa corr(ar1) robust

* Models of Senate speeches on China presented in Table 4
xtnbreg chinanegspeech forbornpct somecoll mdnincm dwnom1 union cxint cmsens, pa corr(ar1) robust
mfx
mfx, at(cmsens=0.0029)
mfx, at(cxint=0.00072)
mfx, at(cxint=0.00027)

xtnbreg chntrdsanct forbornpct somecoll mdnincm dwnom1 union cxint cmsens, pa corr(ar1) robust
mfx
mfx, at(cmsens=0.0029)
mfx, at(cxint=0.00072)
mfx, at(cxint=0.00027)

* Models of speech targets for Table 5 and marginal effects in Table 6
use "C:\replication\speechtarget.dta", clear
xtset ccode year
xi: xtnbreg negspeech i.physint ainr avmdia2 lnpop2 alliance aid dyadmid10 lnexpab lnwimp lnFDI lngdp, pa corr(ar1) robust
test  _Iphysint_1 _Iphysint_2 _Iphysint_3 _Iphysint_4 _Iphysint_5 _Iphysint_6 _Iphysint_7 _Iphysint_8
predict pred_all if e(sample), rate
gen sample_all=1 if pred_all~=.
* Expected counts at levels of physical integrity index
* physint=0
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=1
mfx, at( _Iphysint_1=1 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=2
mfx, at( _Iphysint_1=0 _Iphysint_2=1 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=3
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=1 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=4
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=5
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=1 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=6
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=1 _Iphysint_7=0 _Iphysint_8=0)
* physint=7
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=1 _Iphysint_8=0)
* physint=8
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=1)
* Expected count when dyadmid=0 and physint=4
mfx, at(dyadmid10=0 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count when dyadmid=2 and physint=4
mfx, at(dyadmid10=2 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count when news coverage increases and physint=4
mfx, at(avmdia2=2.17 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count when population increases by one standard deviation
mfx, at(lnpop2=10.66 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)

xi: xtnbreg negspeech i.physint ainr avmdia2 lnpop2 alliance aid dyadmid10 lnexpab lnwimp lnFDI lngdp if wholetime4==1, pa corr(ar1) robust
test  _Iphysint_1 _Iphysint_2 _Iphysint_3 _Iphysint_4
predict pred_wt if e(sample), rate
gen sample_wt=1 if pred_wt~=.
* Expected counts at levels of physical integrity index
* physint=0
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=1
mfx, at( _Iphysint_1=1 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=2
mfx, at( _Iphysint_1=0 _Iphysint_2=1 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=3
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=1 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=4
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=5
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=1 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=6
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=1 _Iphysint_7=0 _Iphysint_8=0)
* physint=7
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=1 _Iphysint_8=0)
* physint=8
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=1)
* Expected count at high level of exports, physint=4
mfx, at(lnexpab=1.79 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count at low level of exports, physint=4
mfx, at(lnexpab=0.01 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count at high level of weighted imports
mfx, at(lnwimp=0.15 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count when GDP is one standard deviation over mean
mfx, at(lngdp=6.16 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)

xi: xtnbreg negspeech i.physint ainr avmdia2 lnpop2 alliance aid dyadmid10 lnexpab lnwimp lnFDI lngdp if onetime4==1, pa corr(ar1) robust
test  _Iphysint_1 _Iphysint_2 _Iphysint_3 _Iphysint_4 _Iphysint_5 _Iphysint_6 _Iphysint_7 _Iphysint_8
predict pred_ot if e(sample), rate
gen sample_ot=1 if pred_ot~=.
* Expected counts at levels of physical integrity index
* physint=0
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=1
mfx, at( _Iphysint_1=1 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=2
mfx, at( _Iphysint_1=0 _Iphysint_2=1 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=3
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=1 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=4
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=5
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=1 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* physint=6
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=1 _Iphysint_7=0 _Iphysint_8=0)
* physint=7
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=1 _Iphysint_8=0)
* physint=8
mfx, at( _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=0 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=1)
* Expected count at high level of exports, physint=4
mfx, at(lnexpab=1.48 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count at low level of exports, physint=4
mfx, at(lnexpab=0.01 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count at high level of weighted imports
mfx, at(lnwimp=0.10 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count when news coverage increases and physint=4
mfx, at(avmdia2=2.86 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)
* Expected count when GDP is one standard deviation over mean
mfx, at(lngdp=5.41 _Iphysint_1=0 _Iphysint_2=0 _Iphysint_3=0 _Iphysint_4=1 _Iphysint_5=0 _Iphysint_6=0 _Iphysint_7=0 _Iphysint_8=0)

