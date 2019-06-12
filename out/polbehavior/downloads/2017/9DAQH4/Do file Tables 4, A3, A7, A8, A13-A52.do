********* Tables 4, A3, A7, A8, A13-A52 *************

********************************
****  Immigration **************
********************************

clear

use "IO eksp data.dta"

recode AIOudl CIOudl (7=6) (8=7) (9=8) (10 11 12 6 99=.)
recode q50 (6=.) (7=6) (8=7) (9=8) (10 11 12 13 14 99=.), gen(party)
recode q41_1_Resp-q41_5_Resp q41_7_Resp-q41_9_Resp (11 12 99=.), gen(diindv_1 diindv_2 diindv_3 diindv_4 diindv_5 diindv_6 diindv_7 diindv_8)
label define partylab 1 "SD" 2 "RV" 3 "KO" 4 "SF" 5 "LA" 6 "DF" 7 "VE" 8 "EL"
label values AIOudl CIOudl party partylab
tab1 AIOudl CIOudl diindv_1-diindv_8 party
tab AIOudl, gen(AIOudl_)
tab CIOudl, gen(CIOudl_)
tab party, gen(party_)

gen id=_n

gen pid_1=0
replace pid_1=2 if q46==1 & q47==1 & (q48==2 | q48==3)
replace pid_1=3 if q46==1 & q47==1 & q48==1
replace pid_1=1 if (q46==2 | q46==3) & q49==1
gen pid_2=0
replace pid_2=2 if q46==1 & q47==2 & (q48==2 | q48==3)
replace pid_2=3 if q46==1 & q47==2 & q48==1
replace pid_2=1 if (q46==2 | q46==3) & q49==2
gen pid_3=0
replace pid_3=2 if q46==1 & q47==3 & (q48==2 | q48==3)
replace pid_3=3 if q46==1 & q47==3 & q48==1
replace pid_3=1 if (q46==2 | q46==3) & q49==3
gen pid_4=0
replace pid_4=2 if q46==1 & q47==4 & (q48==2 | q48==3)
replace pid_4=3 if q46==1 & q47==4 & q48==1
replace pid_4=1 if (q46==2 | q46==3) & q49==4
gen pid_5=0
replace pid_5=2 if q46==1 & q47==5 & (q48==2 | q48==3)
replace pid_5=3 if q46==1 & q47==5 & q48==1
replace pid_5=1 if (q46==2 | q46==3) & q49==5
gen pid_6=0
replace pid_6=2 if q46==1 & q47==7 & (q48==2 | q48==3)
replace pid_6=3 if q46==1 & q47==7 & q48==1
replace pid_6=1 if (q46==2 | q46==3) & q49==7
gen pid_7=0
replace pid_7=2 if q46==1 & q47==8 & (q48==2 | q48==3)
replace pid_7=3 if q46==1 & q47==8 & q48==1
replace pid_7=1 if (q46==2 | q47==3) & q49==8
gen pid_8=0
replace pid_8=2 if q46==1 & q47==9 & (q48==2 | q48==3)
replace pid_8=3 if q46==1 & q47==9 & q48==1
replace pid_8=1 if (q46==2 | q46==3) & q49==9

reshape long AIOudl_ CIOudl_ party_ pid_ diindv_, i(id) j(parti 1-8) 

tab parti, gen(pd)

gen markvar=1
replace markvar=0 if pid_==. | diindv_==.
*tab markvar
drop if markvar==0

gen dist = -(diindv)
gen aio = AIOudl_
gen cio = CIOudl_

log using "H:\POLIS\IO projekt\IO eksp resultater2", replace

*Immigrants

bysort ranBlock1: clogit aio pd1-pd7, group(id)
bysort ranBlock1: clogit aio pd1-pd7 pid , group(id)
bysort ranBlock1: clogit aio pd1-pd7 pid dist, group(id)

clogit aio pd1-pd7 pid dist if ranBlock1==1, group(id)
test pid=0.6355246
test dist= -0.7913804

clogit aio pd1-pd7 pid dist if ranBlock1==2, group(id)
test pid=0.6355246
test dist= -0.7913804

clogit aio pd1-pd7 pid dist if ranBlock1==3, group(id)
test pid=0.6355246
test dist= -0.7913804

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=1
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFea1=r(mfe1) MFfa1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=2
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe2 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff2 = rt2
end
bootstrap MFea2=r(mfe2) MFfa2=r(mff2), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=3
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe3 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff3 = rt2
end
bootstrap MFea3=r(mfe3) MFfa3=r(mff3), seed(9) r(1000) nodots: bsmf

drop if ranBlock1==3

recode ranBlock2 (2 =.)
bysort ranBlock2: clogit cio pd1-pd7, group(id) 
bysort ranBlock2: clogit cio pd1-pd7 pid , group(id)
bysort ranBlock2: clogit cio pd1-pd7 pid dist, group(id)

recode ranBlock2 (2 3 5 6 7=.), gen(test14)
clogit cio pd1-pd7 pid c.test14 pd1#test14 pd2#test14 pd3#test14 pd4#test14 pd5#test14 pd6#test14 pd7#test14 c.test14#c.pid , group(id)
clogit cio pd1-pd7 dist c.test14 pd1#test14 pd2#test14 pd3#test14 pd4#test14 pd5#test14 pd6#test14 pd7#test14 c.test14#c.dist , group(id)

recode ranBlock2 (2 3 4 6 7=.), gen(test15)
clogit cio pd1-pd7 pid c.test15 pd1#test15 pd2#test15 pd3#test15 pd4#test15 pd5#test15 pd6#test15 pd7#test15 c.test15#c.pid , group(id)
clogit cio pd1-pd7 dist c.test15 pd1#test15 pd2#test15 pd3#test15 pd4#test15 pd5#test15 pd6#test15 pd7#test15 c.test15#c.dist , group(id)

recode ranBlock2 (2 3 4 5 7=.), gen(test16)
clogit cio pd1-pd7 pid c.test16 pd1#test16 pd2#test16 pd3#test16 pd4#test16 pd5#test16 pd6#test16 pd7#test16 c.test16#c.pid , group(id)
clogit cio pd1-pd7 dist c.test16 pd1#test16 pd2#test16 pd3#test16 pd4#test16 pd5#test16 pd6#test16 pd7#test16 c.test16#c.dist , group(id)

recode ranBlock2 (2 3 4 5 6=.), gen(test17)
clogit cio pd1-pd7 pid c.test17 pd1#test17 pd2#test17 pd3#test17 pd4#test17 pd5#test17 pd6#test17 pd7#test17 c.test17#c.pid , group(id)
clogit cio pd1-pd7 dist c.test17 pd1#test17 pd2#test17 pd3#test17 pd4#test17 pd5#test17 pd6#test17 pd7#test17 c.test17#c.dist , group(id)

recode ranBlock2 (1 2 3 6 7=.), gen(test45)
clogit cio pd1-pd7 pid c.test45 pd1#test45 pd2#test45 pd3#test45 pd4#test45 pd5#test45 pd6#test45 pd7#test45 c.test45#c.pid , group(id)
clogit cio pd1-pd7 dist c.test45 pd1#test45 pd2#test45 pd3#test45 pd4#test45 pd5#test45 pd6#test45 pd7#test45 c.test45#c.dist , group(id)

recode ranBlock2 (1 2 3 4 5=.), gen(test67)
clogit cio pd1-pd7 pid c.test67 pd1#test67 pd2#test67 pd3#test67 pd4#test67 pd5#test67 pd6#test67 pd7#test67 c.test67#c.pid , group(id)
clogit cio pd1-pd7 dist c.test67 pd1#test67 pd2#test67 pd3#test67 pd4#test67 pd5#test67 pd6#test67 pd7#test67 c.test67#c.dist , group(id)

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=1
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec1=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=3
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe3 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff3 = rt2
end
bootstrap MFec3=r(mfe3) MFfc3=r(mff3), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=4
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe4 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff4 = rt2
end
bootstrap MFec4=r(mfe4) MFfc4=r(mff4), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=5
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe5 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff5 = rt2
end
bootstrap MFuc5=r(mfe5) MFfc5=r(mff5), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=6
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe6 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff6 = rt2
end
bootstrap MFec6=r(mfe6) MFfc6=r(mff6), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=7
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe7 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff7 = rt2
end
bootstrap MFec7=r(mfe7) MFfc7=r(mff7), seed(9) r(1000) nodots: bsmf

log off

********************************
****  Tax policy       ***************
********************************

clear

use "IO eksp data.dta"

recode AIOskat CIOskat (7=6) (8=7) (9=8) (10 11 12 6 99=.)
recode q50 (6=.) (7=6) (8=7) (9=8) (10 11 12 13 14 99=.), gen(party)
recode q42_1_Resp-q42_5_Resp q42_7_Resp-q42_9_Resp (11 12 99=.), gen(diskat_1 diskat_2 diskat_3 diskat_4 diskat_5 diskat_6 diskat_7 diskat_8)
label define partylab 1 "SD" 2 "RV" 3 "KO" 4 "SF" 5 "LA" 6 "DF" 7 "VE" 8 "EL"
label values AIOskat CIOskat party partylab
tab1 AIOskat CIOskat diskat_1-diskat_8 party
tab CIOskat, gen(CIOskat_)
tab AIOskat, gen(AIOskat_)
tab party, gen(party_)

gen id=_n

gen pid_1=0
replace pid_1=2 if q46==1 & q47==1 & (q48==2 | q48==3)
replace pid_1=3 if q46==1 & q47==1 & q48==1
replace pid_1=1 if (q46==2 | q46==3) & q49==1
gen pid_2=0
replace pid_2=2 if q46==1 & q47==2 & (q48==2 | q48==3)
replace pid_2=3 if q46==1 & q47==2 & q48==1
replace pid_2=1 if (q46==2 | q46==3) & q49==2
gen pid_3=0
replace pid_3=2 if q46==1 & q47==3 & (q48==2 | q48==3)
replace pid_3=3 if q46==1 & q47==3 & q48==1
replace pid_3=1 if (q46==2 | q46==3) & q49==3
gen pid_4=0
replace pid_4=2 if q46==1 & q47==4 & (q48==2 | q48==3)
replace pid_4=3 if q46==1 & q47==4 & q48==1
replace pid_4=1 if (q46==2 | q46==3) & q49==4
gen pid_5=0
replace pid_5=2 if q46==1 & q47==5 & (q48==2 | q48==3)
replace pid_5=3 if q46==1 & q47==5 & q48==1
replace pid_5=1 if (q46==2 | q46==3) & q49==5
gen pid_6=0
replace pid_6=2 if q46==1 & q47==7 & (q48==2 | q48==3)
replace pid_6=3 if q46==1 & q47==7 & q48==1
replace pid_6=1 if (q46==2 | q46==3) & q49==7
gen pid_7=0
replace pid_7=2 if q46==1 & q47==8 & (q48==2 | q48==3)
replace pid_7=3 if q46==1 & q47==8 & q48==1
replace pid_7=1 if (q46==2 | q47==3) & q49==8
gen pid_8=0
replace pid_8=2 if q46==1 & q47==9 & (q48==2 | q48==3)
replace pid_8=3 if q46==1 & q47==9 & q48==1
replace pid_8=1 if (q46==2 | q46==3) & q49==9

reshape long AIOskat_ CIOskat_ party_ pid_ diskat_, i(id) j(parti 1-8) 

tab parti, gen(pd)

gen dist = -(diskat)
gen aio = AIOskat_
gen cio = CIOskat_

gen markvar=1
replace markvar=0 if pid_==. | dist==.
*tab markvar
drop if markvar==0

log on

*Tax

bysort ranBlock1: clogit aio pd1-pd7, group(id)
bysort ranBlock1: clogit aio pd1-pd7 pid , group(id)
bysort ranBlock1: clogit aio pd1-pd7 pid dist, group(id)

clogit aio pd1-pd7 pid dist if ranBlock1==1, group(id)
test pid=0.7594758
test dist= -1.001055

clogit aio pd1-pd7 pid dist if ranBlock1==2, group(id)
test pid=0.7594758
test dist= -1.001055

clogit aio pd1-pd7 pid dist if ranBlock1==3, group(id)
test pid=0.7594758
test dist= -1.001055

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=1
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFea1=r(mfe1) MFfa1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=2
 clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe2 = rt1
 clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff2 = rt2
end
bootstrap MFea2=r(mfe2) MFfa2=r(mff2), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=3
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe3 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff3 = rt2
end
bootstrap MFea3=r(mfe3) MFfa3=r(mff3), seed(9) r(1000) nodots: bsmf

drop if ranBlock1==3

recode ranBlock2 (2 =.)
bysort ranBlock2: clogit cio pd1-pd7, group(id)
bysort ranBlock2: clogit cio pd1-pd7 pid , group(id)
bysort ranBlock2: clogit cio pd1-pd7 pid dist, group(id)

recode ranBlock2 (2 3 5 6 7=.), gen(test14)
clogit cio pd1-pd7 pid c.test14 pd1#test14 pd2#test14 pd3#test14 pd4#test14 pd5#test14 pd6#test14 pd7#test14 c.test14#c.pid , group(id)
clogit cio pd1-pd7 dist c.test14 pd1#test14 pd2#test14 pd3#test14 pd4#test14 pd5#test14 pd6#test14 pd7#test14 c.test14#c.dist , group(id)

recode ranBlock2 (2 3 4 6 7=.), gen(test15)
clogit cio pd1-pd7 pid c.test15 pd1#test15 pd2#test15 pd3#test15 pd4#test15 pd5#test15 pd6#test15 pd7#test15 c.test15#c.pid , group(id)
clogit cio pd1-pd7 dist c.test15 pd1#test15 pd2#test15 pd3#test15 pd4#test15 pd5#test15 pd6#test15 pd7#test15 c.test15#c.dist , group(id)

recode ranBlock2 (2 3 4 5 7=.), gen(test16)
clogit cio pd1-pd7 pid c.test16 pd1#test16 pd2#test16 pd3#test16 pd4#test16 pd5#test16 pd6#test16 pd7#test16 c.test16#c.pid , group(id)
clogit cio pd1-pd7 dist c.test16 pd1#test16 pd2#test16 pd3#test16 pd4#test16 pd5#test16 pd6#test16 pd7#test16 c.test16#c.dist , group(id)

recode ranBlock2 (2 3 4 5 6=.), gen(test17)
clogit cio pd1-pd7 pid c.test17 pd1#test17 pd2#test17 pd3#test17 pd4#test17 pd5#test17 pd6#test17 pd7#test17 c.test17#c.pid , group(id)
clogit cio pd1-pd7 dist c.test17 pd1#test17 pd2#test17 pd3#test17 pd4#test17 pd5#test17 pd6#test17 pd7#test17 c.test17#c.dist , group(id)

recode ranBlock2 (1 2 3 6 7=.), gen(test45)
clogit cio pd1-pd7 pid c.test45 pd1#test45 pd2#test45 pd3#test45 pd4#test45 pd5#test45 pd6#test45 pd7#test45 c.test45#c.pid , group(id)
clogit cio pd1-pd7 dist c.test45 pd1#test45 pd2#test45 pd3#test45 pd4#test45 pd5#test45 pd6#test45 pd7#test45 c.test45#c.dist , group(id)

recode ranBlock2 (1 2 3 4 5=.), gen(test67)
clogit cio pd1-pd7 pid c.test67 pd1#test67 pd2#test67 pd3#test67 pd4#test67 pd5#test67 pd6#test67 pd7#test67 c.test67#c.pid , group(id)
clogit cio pd1-pd7 dist c.test67 pd1#test67 pd2#test67 pd3#test67 pd4#test67 pd5#test67 pd6#test67 pd7#test67 c.test67#c.dist , group(id)

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=1
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec1=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

//program drop bsmf
program bsmf1, rclass
preserve
drop if ranBlock2~=3
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe3 = rt1
end
bootstrap MFec3=r(mfe3), seed(9) r(1000) nodots: bsmf1

//program drop bsmf2
program bsmf2, rclass
preserve
drop if ranBlock2~=3
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff3 = rt2
end
bootstrap MFfc3=r(mff3), seed(7) r(1000) nodots: bsmf2

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=4
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe4 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff4 = rt2
end
bootstrap MFec4=r(mfe4) MFfc4=r(mff4), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=5
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe5 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff5 = rt2
end
bootstrap MFuc5=r(mfe5) MFfc5=r(mff5), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=6
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe6 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff6 = rt2
end
bootstrap MFec6=r(mfe6) MFfc6=r(mff6), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=7
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe7 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff7 = rt2
end
bootstrap MFec7=r(mfe7) MFfc7=r(mff7), seed(9) r(1000) nodots: bsmf

log off

********************************
**** Unemployment  *************
********************************

clear

use "IO eksp data.dta"

recode AIOarbl CIOarbl (7=6) (8=7) (9=8) (10 11 12 6 99=.)
recode q50 (6=.) (7=6) (8=7) (9=8) (10 11 12 13 14 99=.), gen(party)
recode q43_1_Resp-q43_5_Resp q43_7_Resp-q43_9_Resp (11 12 99=.), gen(diarbl_1 diarbl_2 diarbl_3 diarbl_4 diarbl_5 diarbl_6 diarbl_7 diarbl_8)
label define partylab 1 "SD" 2 "RV" 3 "KO" 4 "SF" 5 "LA" 6 "DF" 7 "VE" 8 "EL"
label values AIOarbl CIOarbl party partylab
tab1 AIOarbl CIOarbl diarbl_1-diarbl_8 party
tab AIOarbl, gen(AIOarbl_)
tab CIOarbl, gen(CIOarbl_)
tab party, gen(party_)

gen id=_n

gen pid_1=0
replace pid_1=2 if q46==1 & q47==1 & (q48==2 | q48==3)
replace pid_1=3 if q46==1 & q47==1 & q48==1
replace pid_1=1 if (q46==2 | q46==3) & q49==1
gen pid_2=0
replace pid_2=2 if q46==1 & q47==2 & (q48==2 | q48==3)
replace pid_2=3 if q46==1 & q47==2 & q48==1
replace pid_2=1 if (q46==2 | q46==3) & q49==2
gen pid_3=0
replace pid_3=2 if q46==1 & q47==3 & (q48==2 | q48==3)
replace pid_3=3 if q46==1 & q47==3 & q48==1
replace pid_3=1 if (q46==2 | q46==3) & q49==3
gen pid_4=0
replace pid_4=2 if q46==1 & q47==4 & (q48==2 | q48==3)
replace pid_4=3 if q46==1 & q47==4 & q48==1
replace pid_4=1 if (q46==2 | q46==3) & q49==4
gen pid_5=0
replace pid_5=2 if q46==1 & q47==5 & (q48==2 | q48==3)
replace pid_5=3 if q46==1 & q47==5 & q48==1
replace pid_5=1 if (q46==2 | q46==3) & q49==5
gen pid_6=0
replace pid_6=2 if q46==1 & q47==7 & (q48==2 | q48==3)
replace pid_6=3 if q46==1 & q47==7 & q48==1
replace pid_6=1 if (q46==2 | q46==3) & q49==7
gen pid_7=0
replace pid_7=2 if q46==1 & q47==8 & (q48==2 | q48==3)
replace pid_7=3 if q46==1 & q47==8 & q48==1
replace pid_7=1 if (q46==2 | q47==3) & q49==8
gen pid_8=0
replace pid_8=2 if q46==1 & q47==9 & (q48==2 | q48==3)
replace pid_8=3 if q46==1 & q47==9 & q48==1
replace pid_8=1 if (q46==2 | q46==3) & q49==9

reshape long AIOarbl_ CIOarbl_ party_ pid_ diarbl_, i(id) j(parti 1-8) 

tab parti, gen(pd)

gen dist = -(diarbl)
gen aio = AIOarbl_
gen cio = CIOarbl_

gen markvar=1
replace markvar=0 if pid_==. | dist==.
*tab markvar
drop if markvar==0

log on

*Unemployment

//recode ranBlock1 (3=.)
bysort ranBlock1: clogit aio pd1-pd7, group(id)
bysort ranBlock1: clogit aio pd1-pd7 pid , group(id)
bysort ranBlock1: clogit aio pd1-pd7 pid dist, group(id)

clogit aio pd1-pd7 pid dist if ranBlock1==1, group(id)
test pid=0.7067451
test dist= -0.8048411

clogit aio pd1-pd7 pid dist if ranBlock1==2, group(id)
test pid=0.7067451
test dist= -0.8048411

clogit aio pd1-pd7 pid dist if ranBlock1==3, group(id)
test pid=0.7067451
test dist= -0.8048411

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=1
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFea1=r(mfe1) MFfa1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=2
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe2 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff2 = rt2
end
bootstrap MFea2=r(mfe2) MFfa2=r(mff2), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=3
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe3 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff3 = rt2
end
bootstrap MFea3=r(mfe3) MFfa3=r(mff3), seed(9) r(1000) nodots: bsmf

drop if ranBlock1==3

recode ranBlock2 (2=.)
bysort ranBlock2: clogit cio pd1-pd7, group(id)
bysort ranBlock2: clogit cio pd1-pd7 pid , group(id)
bysort ranBlock2: clogit cio pd1-pd7 pid dist, group(id)

recode ranBlock2 (2 3 5 6 7=.), gen(test14)
clogit cio pd1-pd7 pid c.test14 pd1#test14 pd2#test14 pd3#test14 pd4#test14 pd5#test14 pd6#test14 pd7#test14 c.test14#c.pid , group(id)
clogit cio pd1-pd7 dist c.test14 pd1#test14 pd2#test14 pd3#test14 pd4#test14 pd5#test14 pd6#test14 pd7#test14 c.test14#c.dist , group(id)

recode ranBlock2 (2 3 4 6 7=.), gen(test15)
clogit cio pd1-pd7 pid c.test15 pd1#test15 pd2#test15 pd3#test15 pd4#test15 pd5#test15 pd6#test15 pd7#test15 c.test15#c.pid , group(id)
clogit cio pd1-pd7 dist c.test15 pd1#test15 pd2#test15 pd3#test15 pd4#test15 pd5#test15 pd6#test15 pd7#test15 c.test15#c.dist , group(id)

recode ranBlock2 (2 3 4 5 7=.), gen(test16)
clogit cio pd1-pd7 pid c.test16 pd1#test16 pd2#test16 pd3#test16 pd4#test16 pd5#test16 pd6#test16 pd7#test16 c.test16#c.pid , group(id)
clogit cio pd1-pd7 dist c.test16 pd1#test16 pd2#test16 pd3#test16 pd4#test16 pd5#test16 pd6#test16 pd7#test16 c.test16#c.dist , group(id)

recode ranBlock2 (2 3 4 5 6=.), gen(test17)
clogit cio pd1-pd7 pid c.test17 pd1#test17 pd2#test17 pd3#test17 pd4#test17 pd5#test17 pd6#test17 pd7#test17 c.test17#c.pid , group(id)
clogit cio pd1-pd7 dist c.test17 pd1#test17 pd2#test17 pd3#test17 pd4#test17 pd5#test17 pd6#test17 pd7#test17 c.test17#c.dist , group(id)

recode ranBlock2 (1 2 3 6 7=.), gen(test45)
clogit cio pd1-pd7 pid c.test45 pd1#test45 pd2#test45 pd3#test45 pd4#test45 pd5#test45 pd6#test45 pd7#test45 c.test45#c.pid , group(id)
clogit cio pd1-pd7 dist c.test45 pd1#test45 pd2#test45 pd3#test45 pd4#test45 pd5#test45 pd6#test45 pd7#test45 c.test45#c.dist , group(id)

recode ranBlock2 (1 2 3 4 5=.), gen(test67)
clogit cio pd1-pd7 pid c.test67 pd1#test67 pd2#test67 pd3#test67 pd4#test67 pd5#test67 pd6#test67 pd7#test67 c.test67#c.pid , group(id)
clogit cio pd1-pd7 dist c.test67 pd1#test67 pd2#test67 pd3#test67 pd4#test67 pd5#test67 pd6#test67 pd7#test67 c.test67#c.dist , group(id)

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=1
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec1=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=3
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe3 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff3 = rt2
end
bootstrap MFec3=r(mfe3) MFfc3=r(mff3), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=4
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe4 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff4 = rt2
end
bootstrap MFec4=r(mfe4) MFfc4=r(mff4), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=5
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe5 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff5 = rt2
end
bootstrap MFuc5=r(mfe5) MFfc5=r(mff5), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=6
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe6 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff6 = rt2
end
bootstrap MFec6=r(mfe6) MFfc6=r(mff6), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=7
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe7 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff7 = rt2
end
bootstrap MFec7=r(mfe7) MFfc7=r(mff7), seed(9) r(1000) nodots: bsmf

log off

********************************
****  The economy  *************
********************************

clear

use "IO eksp data.dta"

recode AIOecon CIOecon (7=6) (8=7) (9=8) (10 11 12 6 99=.)
recode q50 (6=.) (7=6) (8=7) (9=8) (10 11 12 13 14 99=.), gen(party)
recode q44_1_Resp-q44_5_Resp q44_7_Resp-q44_9_Resp (11 12 99=.), gen(diecon_1 diecon_2 diecon_3 diecon_4 diecon_5 diecon_6 diecon_7 diecon_8)
label define partylab 1 "SD" 2 "RV" 3 "KO" 4 "SF" 5 "LA" 6 "DF" 7 "VE" 8 "EL"
label values AIOecon CIOecon party partylab
tab1 AIOecon CIOecon diecon_1-diecon_8 party
tab AIOecon, gen(AIOecon_)
tab CIOecon, gen(CIOecon_)
tab party, gen(party_)

gen id=_n

gen pid_1=0
replace pid_1=2 if q46==1 & q47==1 & (q48==2 | q48==3)
replace pid_1=3 if q46==1 & q47==1 & q48==1
replace pid_1=1 if (q46==2 | q46==3) & q49==1
gen pid_2=0
replace pid_2=2 if q46==1 & q47==2 & (q48==2 | q48==3)
replace pid_2=3 if q46==1 & q47==2 & q48==1
replace pid_2=1 if (q46==2 | q46==3) & q49==2
gen pid_3=0
replace pid_3=2 if q46==1 & q47==3 & (q48==2 | q48==3)
replace pid_3=3 if q46==1 & q47==3 & q48==1
replace pid_3=1 if (q46==2 | q46==3) & q49==3
gen pid_4=0
replace pid_4=2 if q46==1 & q47==4 & (q48==2 | q48==3)
replace pid_4=3 if q46==1 & q47==4 & q48==1
replace pid_4=1 if (q46==2 | q46==3) & q49==4
gen pid_5=0
replace pid_5=2 if q46==1 & q47==5 & (q48==2 | q48==3)
replace pid_5=3 if q46==1 & q47==5 & q48==1
replace pid_5=1 if (q46==2 | q46==3) & q49==5
gen pid_6=0
replace pid_6=2 if q46==1 & q47==7 & (q48==2 | q48==3)
replace pid_6=3 if q46==1 & q47==7 & q48==1
replace pid_6=1 if (q46==2 | q46==3) & q49==7
gen pid_7=0
replace pid_7=2 if q46==1 & q47==8 & (q48==2 | q48==3)
replace pid_7=3 if q46==1 & q47==8 & q48==1
replace pid_7=1 if (q46==2 | q47==3) & q49==8
gen pid_8=0
replace pid_8=2 if q46==1 & q47==9 & (q48==2 | q48==3)
replace pid_8=3 if q46==1 & q47==9 & q48==1
replace pid_8=1 if (q46==2 | q46==3) & q49==9

reshape long AIOecon_ CIOecon_ party_ pid_ diecon_, i(id) j(parti 1-8) 

tab parti, gen(pd)

gen dist = -(diecon)
gen aio = AIOecon_
gen cio = CIOecon_

gen markvar=1
replace markvar=0 if pid_==. | dist==.
*tab markvar
drop if markvar==0

log on

*The economy

//recode ranBlock1 (3=.)
bysort ranBlock1: clogit aio pd1-pd7, group(id)
bysort ranBlock1: clogit aio pd1-pd7 pid , group(id)
bysort ranBlock1: clogit aio pd1-pd7 pid dist, group(id)

clogit aio pd1-pd7 pid dist if ranBlock1==1, group(id)
test pid=0.9707116
test dist=  -.9451715

clogit aio pd1-pd7 pid dist if ranBlock1==2, group(id)
test pid=0.9707116
test dist=  -.9451715

clogit aio pd1-pd7 pid dist if ranBlock1==3, group(id)
test pid=0.9707116
test dist=  -.9451715

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=1
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFea1=r(mfe1) MFfa1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=2
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe2 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff2 = rt2
end
bootstrap MFea2=r(mfe2) MFfa2=r(mff2), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=3
qui clogit aio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe3 = rt1
qui clogit aio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff3 = rt2
end
bootstrap MFea3=r(mfe3) MFfa3=r(mff3), seed(9) r(1000) nodots: bsmf

drop if ranBlock1==3

recode ranBlock2 (2 =.)
bysort ranBlock2: clogit cio pd1-pd7, group(id)
bysort ranBlock2: clogit cio pd1-pd7 pid , group(id)
bysort ranBlock2: clogit cio pd1-pd7 pid dist, group(id)

recode ranBlock2 (2 3 5 6 7=.), gen(test14)
clogit cio pd1-pd7 pid c.test14 pd1#test14 pd2#test14 pd3#test14 pd4#test14 pd5#test14 pd6#test14 pd7#test14 c.test14#c.pid , group(id)
clogit cio pd1-pd7 dist c.test14 pd1#test14 pd2#test14 pd3#test14 pd4#test14 pd5#test14 pd6#test14 pd7#test14 c.test14#c.dist , group(id)

recode ranBlock2 (2 3 4 6 7=.), gen(test15)
clogit cio pd1-pd7 pid c.test15 pd1#test15 pd2#test15 pd3#test15 pd4#test15 pd5#test15 pd6#test15 pd7#test15 c.test15#c.pid , group(id)
clogit cio pd1-pd7 dist c.test15 pd1#test15 pd2#test15 pd3#test15 pd4#test15 pd5#test15 pd6#test15 pd7#test15 c.test15#c.dist , group(id)

recode ranBlock2 (2 3 4 5 7=.), gen(test16)
clogit cio pd1-pd7 pid c.test16 pd1#test16 pd2#test16 pd3#test16 pd4#test16 pd5#test16 pd6#test16 pd7#test16 c.test16#c.pid , group(id)
clogit cio pd1-pd7 dist c.test16 pd1#test16 pd2#test16 pd3#test16 pd4#test16 pd5#test16 pd6#test16 pd7#test16 c.test16#c.dist , group(id)

recode ranBlock2 (2 3 4 5 6=.), gen(test17)
clogit cio pd1-pd7 pid c.test17 pd1#test17 pd2#test17 pd3#test17 pd4#test17 pd5#test17 pd6#test17 pd7#test17 c.test17#c.pid , group(id)
clogit cio pd1-pd7 dist c.test17 pd1#test17 pd2#test17 pd3#test17 pd4#test17 pd5#test17 pd6#test17 pd7#test17 c.test17#c.dist , group(id)

recode ranBlock2 (1 2 3 6 7=.), gen(test45)
clogit cio pd1-pd7 pid c.test45 pd1#test45 pd2#test45 pd3#test45 pd4#test45 pd5#test45 pd6#test45 pd7#test45 c.test45#c.pid , group(id)
clogit cio pd1-pd7 dist c.test45 pd1#test45 pd2#test45 pd3#test45 pd4#test45 pd5#test45 pd6#test45 pd7#test45 c.test45#c.dist , group(id)

recode ranBlock2 (1 2 3 4 5=.), gen(test67)
clogit cio pd1-pd7 pid c.test67 pd1#test67 pd2#test67 pd3#test67 pd4#test67 pd5#test67 pd6#test67 pd7#test67 c.test67#c.pid , group(id)
clogit cio pd1-pd7 dist c.test67 pd1#test67 pd2#test67 pd3#test67 pd4#test67 pd5#test67 pd6#test67 pd7#test67 c.test67#c.dist , group(id)


program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=1
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec1=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=3
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe3 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff3 = rt2
end
bootstrap MFec3=r(mfe3) MFfc3=r(mff3), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=4
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe4 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff4 = rt2
end
bootstrap MFec4=r(mfe4) MFfc4=r(mff4), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=5
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe5 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff5 = rt2
end
bootstrap MFuc5=r(mfe5) MFfc5=r(mff5), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=6
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe6 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff6 = rt2
end
bootstrap MFec6=r(mfe6) MFfc6=r(mff6), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock2~=7
qui clogit cio pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe7 = rt1
qui clogit cio pd1-pd7 pid dist, group(id)
scalar rt2=e(r2_p)
return scalar mff7 = rt2
end
bootstrap MFec7=r(mfe7) MFfc7=r(mff7), seed(9) r(1000) nodots: bsmf

log close
