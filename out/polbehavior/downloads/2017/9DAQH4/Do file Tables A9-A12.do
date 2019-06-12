clear

use "IO ekspt 2016.dta"

gen CIOudl=V1_q1
replace CIOudl=V2_q1 if ranBlock1==2
replace CIOudl=V3_q1 if ranBlock1==3
tab CIOudl

gen CIOskat=V1_q2
replace CIOskat=V2_q2 if ranBlock1==2
replace CIOskat=V3_q2 if ranBlock1==3
tab CIOskat

gen CIOarbl=V1_q3
replace CIOarbl=V2_q3 if ranBlock1==2
replace CIOarbl=V3_q3 if ranBlock1==3
tab CIOarbl

gen CIOecon=V1_q4
replace CIOecon=V2_q4 if ranBlock1==2
replace CIOecon=V3_q4 if ranBlock1==3
tab CIOecon

gen version = ranBlock1

set seed 1

//Inference for Duncan scores//

program drop Dudl
program Dudl, rclass
duncan CIOudl version
matrix a = r(D)
scalar b = a[2,1]
scalar list b
return scalar d = b
end
bootstrap UdlD1=r(d), r(1000) nodots: Dudl

program drop Dudl
program Dudl, rclass
duncan CIOudl version
matrix a = r(D)
scalar b = a[3,1]
scalar list b
return scalar d = b
end
bootstrap UdlD2=r(d), r(1000) nodots: Dudl

program drop Dudl
program Dudl, rclass
duncan CIOudl version
matrix ua = r(D)
scalar ulot = ua[2,1]
scalar usht = ua[3,1]
scalar ultst = (ulot - usht)
scalar list ultst
return scalar ud = ultst
end

bootstrap UdlD1=r(ud), r(1000) nodots: Dudl

program drop Dskat
program Dskat, rclass
duncan CIOskat version
matrix a = r(D)
scalar b = a[2,1]
scalar list b
return scalar d = b
end
bootstrap SkatD1=r(d), r(1000) nodots: Dskat

program drop Dskat
program Dskat, rclass
duncan CIOskat version
matrix a = r(D)
scalar b = a[3,1]
scalar list b
return scalar d = b
end
bootstrap SkatD2=r(d), r(1000) nodots: Dskat

program drop Dskat
program Dskat, rclass
duncan CIOskat version
matrix ua = r(D)
scalar ulot = ua[2,1]
scalar usht = ua[3,1]
scalar ultst = (ulot - usht)
scalar list ultst
return scalar ud = ultst
end

bootstrap UdlD1=r(ud), r(1000) nodots: Dskat

program drop Darbl
program Darbl, rclass
duncan CIOarbl version
matrix a = r(D)
scalar b = a[2,1]
scalar list b
return scalar d = b
end
bootstrap ArblD1=r(d), r(1000) nodots: Darbl

program drop Darbl
program Darbl, rclass
duncan CIOarbl version
matrix a = r(D)
scalar b = a[3,1]
scalar list b
return scalar d = b
end
bootstrap ArblD2=r(d), r(1000) nodots: Darbl

program drop Darbl
program Darbl, rclass
duncan CIOarbl version
matrix ua = r(D)
scalar ulot = ua[2,1]
scalar usht = ua[3,1]
scalar ultst = (ulot - usht)
scalar list ultst
return scalar ud = ultst
end

bootstrap UdlD1=r(ud), r(1000) nodots: Darbl

program drop Decon
program Decon, rclass
duncan CIOecon version
matrix a = r(D)
scalar b = a[2,1]
scalar list b
return scalar d = b
end
bootstrap EconD1=r(d), r(1000) nodots: Decon

program drop Decon
program Decon, rclass
duncan CIOecon version
matrix a = r(D)
scalar b = a[3,1]
scalar list b
return scalar d = b
end
bootstrap EconD2=r(d), r(1000) nodots: Decon

program drop Decon
program Decon, rclass
duncan CIOecon version
matrix ua = r(D)
scalar ulot = ua[2,1]
scalar usht = ua[3,1]
scalar ultst = (ulot - usht)
scalar list ultst
return scalar ud = ultst
end

bootstrap UdlD1=r(ud), r(1000) nodots: Decon

******** Set up for clogit ***********

recode CIOudl CIOskat CIOarbl CIOecon (5=4) (6=5) (8=6) (9=7) (10=8) (4 7 11 12 13 99=.)
recode q50 (5=4) (6=5) (8=6) (9=7) (10=8) (4 7 11 12 13/16 99=.), gen(party)
recode q41_1_Resp-q41_3_Resp q41_5_Resp-q41_6_Resp q41_8_Resp-q41_10_Resp (11 12 99=.), gen(diindv_1 diindv_2 diindv_3 diindv_4 diindv_5 diindv_6 diindv_7 diindv_8)
recode q42_1_Resp-q42_3_Resp q42_5_Resp-q42_6_Resp q42_8_Resp-q42_10_Resp (11 12 99=.), gen(diskat_1 diskat_2 diskat_3 diskat_4 diskat_5 diskat_6 diskat_7 diskat_8)
recode q43_1_Resp-q43_3_Resp q43_5_Resp-q43_6_Resp q43_8_Resp-q43_10_Resp (11 12 99=.), gen(diarbl_1 diarbl_2 diarbl_3 diarbl_4 diarbl_5 diarbl_6 diarbl_7 diarbl_8)
recode q44_1_Resp-q44_3_Resp q44_5_Resp-q44_6_Resp q44_8_Resp-q44_10_Resp (11 12 99=.), gen(diecon_1 diecon_2 diecon_3 diecon_4 diecon_5 diecon_6 diecon_7 diecon_8)
label define partylab 1 "SD" 2 "RV" 3 "KO" 4 "SF" 5 "LA" 6 "DF" 7 "VE" 8 "EL"
label values CIOudl CIOskat CIOarbl CIOecon party partylab
tab1 CIOudl diindv_1-diindv_8 party
tab CIOudl, gen(CIOudl_)
tab CIOskat, gen(CIOskat_)
tab CIOarbl, gen(CIOarbl_)
tab CIOecon, gen(CIOecon_)

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
replace pid_4=2 if q46==1 & q47==5 & (q48==2 | q48==3)
replace pid_4=3 if q46==1 & q47==5 & q48==1
replace pid_4=1 if (q46==2 | q46==3) & q49==5
gen pid_5=0
replace pid_5=2 if q46==1 & q47==6 & (q48==2 | q48==3)
replace pid_5=3 if q46==1 & q47==6 & q48==1
replace pid_5=1 if (q46==2 | q46==3) & q49==6
gen pid_6=0
replace pid_6=2 if q46==1 & q47==8 & (q48==2 | q48==3)
replace pid_6=3 if q46==1 & q47==8 & q48==1
replace pid_6=1 if (q46==2 | q46==3) & q49==8
gen pid_7=0
replace pid_7=2 if q46==1 & q47==9 & (q48==2 | q48==3)
replace pid_7=3 if q46==1 & q47==9 & q48==1
replace pid_7=1 if (q46==2 | q47==3) & q49==9
gen pid_8=0
replace pid_8=2 if q46==1 & q47==10 & (q48==2 | q48==3)
replace pid_8=3 if q46==1 & q47==10 & q48==1
replace pid_8=1 if (q46==2 | q46==3) & q49==10

reshape long CIOudl_ CIOskat_ CIOarbl_ CIOecon_ pid_ diindv_ diskat_ diarbl_ diecon_, i(id) j(parti 1-8) 

tab parti, gen(pd)

gen idist = -(diindv)
gen sdist = -(diskat)
gen adist = -(diarbl)
gen edist = -(diecon)

drop if pid_==.

save "IO ekspt16 kodet.dta"

clear

use "IO ekspt16 kodet.dta"

*Immigration

drop if idist==.

bysort ranBlock1: clogit CIOudl_ pd1-pd7, group(id) 
bysort ranBlock1: clogit CIOudl_ pd1-pd7 pid , group(id)
bysort ranBlock1: clogit CIOudl_ pd1-pd7 pid idist, group(id)

recode ranBlock1 (3=.), gen(test12)
recode ranBlock1 (2=.), gen(test13)
clogit CIOudl_ pd1-pd7 pid c.test12 pd1#test12 pd2#test12 pd3#test12 pd4#test12 pd5#test12 pd6#test12 pd7#test12 c.test12#c.pid , group(id)
clogit CIOudl_ pd1-pd7 idist c.test12 pd1#test12 pd2#test12 pd3#test12 pd4#test12 pd5#test12 pd6#test12 pd7#test12 c.test12#c.idist , group(id)

clogit CIOudl_ pd1-pd7 pid c.test13 pd1#test13 pd2#test13 pd3#test13 pd4#test13 pd5#test13 pd6#test13 pd7#test13 c.test13#c.pid , group(id)
clogit CIOudl_ pd1-pd7 idist c.test13 pd1#test13 pd2#test13 pd3#test13 pd4#test13 pd5#test13 pd6#test13 pd7#test13 c.test13#c.idist , group(id)


program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=1
qui clogit CIOudl_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOudl_ pd1-pd7 pid idist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec1=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=2
qui clogit CIOudl_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOudl_ pd1-pd7 pid idist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec2=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=3
qui clogit CIOudl_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOudl_ pd1-pd7 pid idist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec3=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

*Tax

clear

use "H:\POLIS\IO projekt\PB\IO ekspt16 kodet.dta"

drop if sdist==.

bysort ranBlock1: clogit CIOskat_ pd1-pd7, group(id) 
bysort ranBlock1: clogit CIOskat_ pd1-pd7 pid , group(id)
bysort ranBlock1: clogit CIOskat_ pd1-pd7 pid sdist, group(id)

recode ranBlock1 (3=.), gen(test12)
recode ranBlock1 (2=.), gen(test13)
clogit CIOskat_ pd1-pd7 pid c.test12 pd1#test12 pd2#test12 pd3#test12 pd4#test12 pd5#test12 pd6#test12 pd7#test12 c.test12#c.pid , group(id)
clogit CIOskat_ pd1-pd7 sdist c.test12 pd1#test12 pd2#test12 pd3#test12 pd4#test12 pd5#test12 pd6#test12 pd7#test12 c.test12#c.sdist , group(id)

clogit CIOskat_ pd1-pd7 pid c.test13 pd1#test13 pd2#test13 pd3#test13 pd4#test13 pd5#test13 pd6#test13 pd7#test13 c.test13#c.pid , group(id)
clogit CIOskat_ pd1-pd7 sdist c.test13 pd1#test13 pd2#test13 pd3#test13 pd4#test13 pd5#test13 pd6#test13 pd7#test13 c.test13#c.sdist , group(id)

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=1
qui clogit CIOskat_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOskat_ pd1-pd7 pid sdist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec1=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=2
qui clogit CIOskat_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOskat_ pd1-pd7 pid sdist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec2=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=3
qui clogit CIOskat_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOskat_ pd1-pd7 pid sdist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec3=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

*Unemployment

clear

use "H:\POLIS\IO projekt\PB\IO ekspt16 kodet.dta"

drop if adist==.

bysort ranBlock1: clogit CIOarbl_ pd1-pd7, group(id) 
bysort ranBlock1: clogit CIOarbl_ pd1-pd7 pid , group(id)
bysort ranBlock1: clogit CIOarbl_ pd1-pd7 pid adist, group(id)

recode ranBlock1 (3=.), gen(test12)
recode ranBlock1 (2=.), gen(test13)
clogit CIOarbl_ pd1-pd7 pid c.test12 pd1#test12 pd2#test12 pd3#test12 pd4#test12 pd5#test12 pd6#test12 pd7#test12 c.test12#c.pid , group(id)
clogit CIOarbl_ pd1-pd7 adist c.test12 pd1#test12 pd2#test12 pd3#test12 pd4#test12 pd5#test12 pd6#test12 pd7#test12 c.test12#c.adist , group(id)

clogit CIOarbl_ pd1-pd7 pid c.test13 pd1#test13 pd2#test13 pd3#test13 pd4#test13 pd5#test13 pd6#test13 pd7#test13 c.test13#c.pid , group(id)
clogit CIOarbl_ pd1-pd7 adist c.test13 pd1#test13 pd2#test13 pd3#test13 pd4#test13 pd5#test13 pd6#test13 pd7#test13 c.test13#c.adist , group(id)

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=1
qui clogit CIOarbl_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOarbl_ pd1-pd7 pid adist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec1=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=2
qui clogit CIOarbl_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOarbl_ pd1-pd7 pid adist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec2=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=3
qui clogit CIOarbl_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOarbl_ pd1-pd7 pid adist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec3=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

*The economy

clear

use "H:\POLIS\IO projekt\PB\IO ekspt16 kodet.dta"

drop if edist==.

bysort ranBlock1: clogit CIOecon_ pd1-pd7, group(id) 
bysort ranBlock1: clogit CIOecon_ pd1-pd7 pid , group(id)
bysort ranBlock1: clogit CIOecon_ pd1-pd7 pid edist, group(id)

recode ranBlock1 (3=.), gen(test12)
recode ranBlock1 (2=.), gen(test13)
clogit CIOecon_ pd1-pd7 pid c.test12 pd1#test12 pd2#test12 pd3#test12 pd4#test12 pd5#test12 pd6#test12 pd7#test12 c.test12#c.pid , group(id)
clogit CIOecon_ pd1-pd7 edist c.test12 pd1#test12 pd2#test12 pd3#test12 pd4#test12 pd5#test12 pd6#test12 pd7#test12 c.test12#c.edist , group(id)

clogit CIOecon_ pd1-pd7 pid c.test13 pd1#test13 pd2#test13 pd3#test13 pd4#test13 pd5#test13 pd6#test13 pd7#test13 c.test13#c.pid , group(id)
clogit CIOecon_ pd1-pd7 edist c.test13 pd1#test13 pd2#test13 pd3#test13 pd4#test13 pd5#test13 pd6#test13 pd7#test13 c.test13#c.edist , group(id)

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=1
qui clogit CIOecon_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOecon_ pd1-pd7 pid edist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec1=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=2
qui clogit CIOecon_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOecon_ pd1-pd7 pid edist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec2=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

program drop bsmf
program bsmf, rclass
preserve
drop if ranBlock1~=3
qui clogit CIOecon_ pd1-pd7, group(id)
scalar rt1=e(r2_p)
return scalar mfe1 = rt1
qui clogit CIOecon_ pd1-pd7 pid edist, group(id)
scalar rt2=e(r2_p)
return scalar mff1 = rt2
end
bootstrap MFudlec3=r(mfe1) MFudlfc1=r(mff1), seed(9) r(1000) nodots: bsmf

log off
