clear

use "IO ekspt panel data.dta"

****** Analyses issue by issue

svyset [pweight=wgt_ranBlock]

gen udlens=1 if CIOudl2~=.
replace udlens=0 if CIOudl==CIOudl2

gen skatens=1 if CIOskat2~=.
replace skatens=0 if CIOskat==CIOskat2

gen arblens=1 if CIOarbl2~=.
replace arblens=0 if CIOarbl==CIOarbl2

gen econens=1 if CIOecon2~=.
replace econens=0 if CIOecon==CIOecon2

tab ranBlock2 udlens [aweight=wgt_ranBlock], r
tab ranBlock2 skatens [aweight=wgt_ranBlock], r
tab ranBlock2 arblens [aweight=wgt_ranBlock], r
tab ranBlock2 econens [aweight=wgt_ranBlock], r

mean udlens skatens arblens econens [aweight=wgt_ranBlock], over(ranBlock2)

reg udlens i.ranBlock2  [aweight=wgt_ranBlock]
reg skatens i.ranBlock2  [aweight=wgt_ranBlock]
reg arblens i.ranBlock2  [aweight=wgt_ranBlock]
reg econens i.ranBlock2  [aweight=wgt_ranBlock]

reg udlens i.ranBlock2  if (CIOudl<10 & CIOudl2<10) [aweight=wgt_ranBlock]
reg skatens i.ranBlock2 if (CIOskat<10 & CIOskat2<10)  [aweight=wgt_ranBlock]
reg arblens i.ranBlock2 if (CIOarbl<10 & CIOarbl2<10)  [aweight=wgt_ranBlock]
reg econens i.ranBlock2 if (CIOecon<10 & CIOecon2<10)  [aweight=wgt_ranBlock]

gen udlens2=1 if AIOudl2~=.
replace udlens2=0 if AIOudl==AIOudl2
tab ranBlock1 udlens2 [aweight=wgt_ranBlock], r
svy: mean udlens2 if ranBlock1==1
lincom (udlens2)-0.605
lincom (udlens2)-0.541

gen skatens2=1 if AIOskat2~=.
replace skatens2=0 if AIOskat==AIOskat2
tab ranBlock1 skatens2 [aweight=wgt_ranBlock], r
svy: mean skatens2 if ranBlock1==1
lincom (skatens2)-0.516
lincom (skatens2)-0.356

gen arblens2=1 if AIOarbl2~=.
replace arblens2=0 if AIOarbl==AIOarbl2
tab ranBlock1 arblens2 [aweight=wgt_ranBlock], r
svy: mean arblens2 if ranBlock1==1
lincom (arblens2)-0.581
lincom (arblens2)-0.409

gen econens2=1 if AIOecon2~=.
replace econens2=0 if AIOecon==AIOecon2
tab ranBlock1 econens2 [aweight=wgt_ranBlock], r
svy: mean econens2 if ranBlock1==1
lincom (econens2)-0.498
lincom (econens2)-0.436

mean udlens2 skatens2 arblens2 econens2 [aweight=wgt_ranBlock], over(ranBlock1)
 
*Aggegate analysis across all four issues

gen id2=_n

gen AIO_1=AIOudl
gen AIO_2=AIOskat
gen AIO_3=AIOarbl
gen AIO_4=AIOecon

gen AIO2_1=AIOudl2
gen AIO2_2=AIOskat2
gen AIO2_3=AIOarbl2
gen AIO2_4=AIOecon2

gen CIO_1=CIOudl
gen CIO_2=CIOskat
gen CIO_3=CIOarbl
gen CIO_4=CIOecon

gen CIO2_1=CIOudl2
gen CIO2_2=CIOskat2
gen CIO2_3=CIOarbl2
gen CIO2_4=CIOecon2

reshape long AIO_ AIO2_ CIO_ CIO2_ , i(id2) j(issue 1-4) 

gen cioens=1 if CIO2_~=.
replace cioens=0 if CIO_==CIO2_
tab ranBlock2 cioens [aweight=wgt_ranBlock], r

mean cioens [aweight=wgt_ranBlock], over(ranBlock2) vce(cluster id) 

gen aioens=1 if AIO2_~=.
replace aioens=0 if AIO_==AIO2_
tab ranBlock1 aioens [aweight=wgt_ranBlock], r

mean aioens [aweight=wgt_ranBlock], over(ranBlock1) vce(cluster id) 

reg cioens i.ranBlock2  [aweight=wgt_ranBlock], vce(cluster id)
