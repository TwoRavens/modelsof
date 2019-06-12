clear

capture log close

use "IO eksp data.dta"

*********** Tables 1, 2, A1, A4, A5, A6 **************

tab AIOudl ranBlock1
tab AIOskat ranBlock1
tab AIOarbl ranBlock1
tab AIOecon ranBlock1

drop if ranBlock1==3

tab CIOudl ranBlock2
tab CIOskat ranBlock2
tab CIOarbl ranBlock2
tab CIOecon ranBlock2

recode ranBlock2 (2 =.) (4=2) (5=3) (6=4) (7=5) (3=6)
tab ranBlock2
drop if ranBlock2==.

clonevar version = ranBlock2

// (Include to obtain results without Don't know and 'equally good/bad') recode CIOudl CIOskat CIOarbl CIOecon (10 11=.)

set seed 1

log using "H:\POLIS\IO projekt\Duncaninferens4", replace

duncan CIOudl version
duncan CIOskat version
duncan CIOarbl version
duncan CIOecon version

//Test of differences between Duncan scores

//program drop Dudl
program Dudl, rclass
duncan CIOudl version
matrix ua = r(D)
scalar ulot = ua[2,1]
scalar usht = ua[3,1]
scalar ultst = (ulot - usht)
scalar list ultst
return scalar ud = ultst
scalar ubp = ua[4,1]
scalar ubq = ua[5,1]
scalar ubpbq = ubp-ubq
scalar list ubpbq
return scalar uc = ubpbq
end

bootstrap UdlD1=r(ud) UdlD2=r(uc), r(1000) nodots: Dudl

//program drop Dskat
program Dskat, rclass
duncan CIOskat version
matrix sa = r(D)
scalar slot = sa[2,1]
scalar ssht = sa[3,1]
scalar sltst = (slot - ssht)
scalar list sltst
return scalar sd = sltst
scalar sbp = sa[4,1]
scalar sbq = sa[5,1]
scalar sbpbq = sbp-sbq
scalar list sbpbq
return scalar sc = sbpbq
end

bootstrap SkatD1=r(sd) SkatD2=r(sc), r(1000) nodots: Dskat

//program drop Darbl
program Darbl, rclass
duncan CIOarbl version
matrix aa = r(D)
scalar alot = aa[2,1]
scalar asht = aa[3,1]
scalar altst = (alot - asht)
scalar list altst
return scalar ad = altst
scalar abp = aa[4,1]
scalar abq = aa[5,1]
scalar abpbq = abp-abq
scalar list abpbq
return scalar ac = abpbq
end

bootstrap ArblD1=r(ad) ArblD2=r(ac), r(1000) nodots: Darbl

//program drop Decon
program Decon, rclass
duncan CIOecon version
matrix ea = r(D)
scalar elot = ea[2,1]
scalar esht = ea[3,1]
scalar eltst = (elot - esht)
scalar list eltst
return scalar ed = eltst
scalar ebp = ea[4,1]
scalar ebq = ea[5,1]
scalar ebpbq = ebp-ebq
scalar list ebpbq
return scalar ec = ebpbq
end

bootstrap EconD1=r(ed) EconD2=r(ec), r(1000) nodots: Decon

//Inference for Duncan scores//

recode version (2 3 4 5 6=.)

program drop Dudl
program Dudl, rclass
duncan CIOudl version
matrix a = r(D)
scalar b = a[2,1]
scalar list b
return scalar d = b
end

foreach n of numlist 2/6 {
preserve
replace version = 2 if ranBlock2==`n'
drop if version==.
bootstrap UdlD`n'=r(d), r(1000) nodots: Dudl
restore
}

program drop Dskat
program Dskat, rclass
duncan CIOskat version
matrix a = r(D)
scalar b = a[2,1]
scalar list b
return scalar d = b
end

foreach n of numlist 2/6 {
preserve
replace version = 2 if ranBlock2==`n'
drop if version==.
bootstrap SkatD`n'=r(d), r(1000) nodots: Dskat
restore
}

program drop Darbl
program Darbl, rclass
duncan CIOarbl version
matrix a = r(D)
scalar b = a[2,1]
scalar list b
return scalar d = b
end

foreach n of numlist 2/6 {
preserve
replace version = 2 if ranBlock2==`n'
drop if version==.
bootstrap ArblD`n'=r(d), r(1000) nodots: Darbl
restore
}


program drop Decon
program Decon, rclass
duncan CIOecon version
matrix a = r(D)
scalar b = a[2,1]
scalar list b
return scalar d = b
end

foreach n of numlist 2/6 {
preserve
replace version = 2 if ranBlock2==`n'
drop if version==.
bootstrap EconD`n'=r(d), r(1000) nodots: Decon
restore
}

//Duncan score for AIO v1//

clear

use "IO eksp data.dta"

recode ranBlock1 (2/3=.)
drop if ranBlock1==.
tab ranBlock1

//program drop DAudl
program DAudl, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOudl`n' = 0
qui replace AIOudl`n' = 1 if AIOudl ==`n'
qui sum AIOudl`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.163)
gen a22=abs(a2-0.074)
gen a23=abs(a3-0.015)
gen a24=abs(a4-0.043)
gen a25=abs(a5-0.017)
gen a26=abs(a6-0.004)
gen a27=abs(a7-0.321)
gen a28=abs(a8-0.106)
gen a29=abs(a9-0.059)
gen a210=abs(a10-0.096)
gen a211=abs(a11-0.102)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f=r(gns), r(1000) nodots: DAudl

//program drop DAskat
program DAskat, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOskat`n' = 0
qui replace AIOskat`n' = 1 if AIOskat ==`n'
qui sum AIOskat`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.195)
gen a22=abs(a2-0.053)
gen a23=abs(a3-0.038)
gen a24=abs(a4-0.025)
gen a25=abs(a5-0.056)
gen a26=abs(a6-0.002)
gen a27=abs(a7-0.049)
gen a28=abs(a8-0.253)
gen a29=abs(a9-0.042)
gen a210=abs(a10-0.163)
gen a211=abs(a11-0.127)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f=r(gns), r(1000) nodots: DAskat

//program drop DAarbl
program DAarbl, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOarbl`n' = 0
qui replace AIOarbl`n' = 1 if AIOarbl ==`n'
qui sum AIOarbl`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.231)
gen a22=abs(a2-0.028)
gen a23=abs(a3-0.015)
gen a24=abs(a4-0.036)
gen a25=abs(a5-0.025)
gen a26=abs(a6-0.002)
gen a27=abs(a7-0.051)
gen a28=abs(a8-0.189)
gen a29=abs(a9-0.083)
gen a210=abs(a10-0.227)
gen a211=abs(a11-0.113)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f=r(gns), r(1000) nodots: DAarbl

//program drop DAecon
program DAecon, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOecon`n' = 0
qui replace AIOecon`n' = 1 if AIOecon ==`n'
qui sum AIOecon`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.216)
gen a22=abs(a2-0.066)
gen a23=abs(a3-0.028)
gen a24=abs(a4-0.009)
gen a25=abs(a5-0.028)
gen a26=abs(a6-0.004)
gen a27=abs(a7-0.051)
gen a28=abs(a8-0.285)
gen a29=abs(a9-0.028)
gen a210=abs(a10-0.181)
gen a211=abs(a11-0.102)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f=r(gns), r(1000) nodots: DAecon

//(Include to obtain results without Don't know and 'equally good/bad') recode AIOudl AIOskat AIOarbl AIOecon (10 11=.)

//program drop DAudl
program DAudl, rclass
preserve
foreach n of numlist 1/9 {
qui gen AIOudl`n' = 0
qui replace AIOudl`n' = 1 if AIOudl ==`n'
qui sum AIOudl`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.203)
gen a22=abs(a2-0.092)
gen a23=abs(a3-0.019)
gen a24=abs(a4-0.054)
gen a25=abs(a5-0.021)
gen a26=abs(a6-0.005)
gen a27=abs(a7-0.401)
gen a28=abs(a8-0.132)
gen a29=abs(a9-0.073)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f=r(gns), r(1000) nodots: DAudl

//program drop DAskat
program DAskat, rclass
preserve
foreach n of numlist 1/9 {
qui gen AIOskat`n' = 0
qui replace AIOskat`n' = 1 if AIOskat ==`n'
qui sum AIOskat`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.274)
gen a22=abs(a2-0.075)
gen a23=abs(a3-0.053)
gen a24=abs(a4-0.035)
gen a25=abs(a5-0.077)
gen a26=abs(a6-0.003)
gen a27=abs(a7-0.069)
gen a28=abs(a8-0.356)
gen a29=abs(a9-0.059)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f=r(gns), r(1000) nodots: DAskat

//program drop DAarbl
program DAarbl, rclass
preserve
foreach n of numlist 1/9 {
qui gen AIOarbl`n' = 0
qui replace AIOarbl`n' = 1 if AIOarbl ==`n'
qui sum AIOarbl`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.35)
gen a22=abs(a2-0.043)
gen a23=abs(a3-0.023)
gen a24=abs(a4-0.054)
gen a25=abs(a5-0.037)
gen a26=abs(a6-0.003)
gen a27=abs(a7-0.077)
gen a28=abs(a8-0.287)
gen a29=abs(a9-0.126)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f=r(gns), r(1000) nodots: DAarbl

//program drop DAecon
program DAecon, rclass
preserve
foreach n of numlist 1/9 {
qui gen AIOecon`n' = 0
qui replace AIOecon`n' = 1 if AIOecon ==`n'
qui sum AIOecon`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.301)
gen a22=abs(a2-0.092)
gen a23=abs(a3-0.04)
gen a24=abs(a4-0.013)
gen a25=abs(a5-0.04)
gen a26=abs(a6-0.005)
gen a27=abs(a7-0.071)
gen a28=abs(a8-0.398)
gen a29=abs(a9-0.04)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f=r(gns), r(1000) nodots: DAecon

//Duncan for AIO v2//

clear

use "IO eksp data.dta"

recode ranBlock1 (1 3=.)
drop if ranBlock1==.
tab ranBlock1

program drop DAudl
program DAudl, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOudl`n' = 0
qui replace AIOudl`n' = 1 if AIOudl ==`n'
qui sum AIOudl`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.163)
gen a22=abs(a2-0.074)
gen a23=abs(a3-0.015)
gen a24=abs(a4-0.043)
gen a25=abs(a5-0.017)
gen a26=abs(a6-0.004)
gen a27=abs(a7-0.321)
gen a28=abs(a8-0.106)
gen a29=abs(a9-0.059)
gen a210=abs(a10-0.096)
gen a211=abs(a11-0.102)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f2=r(gns), r(1000) nodots: DAudl

program drop DAskat
program DAskat, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOskat`n' = 0
qui replace AIOskat`n' = 1 if AIOskat ==`n'
qui sum AIOskat`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.195)
gen a22=abs(a2-0.053)
gen a23=abs(a3-0.038)
gen a24=abs(a4-0.025)
gen a25=abs(a5-0.056)
gen a26=abs(a6-0.002)
gen a27=abs(a7-0.049)
gen a28=abs(a8-0.253)
gen a29=abs(a9-0.042)
gen a210=abs(a10-0.163)
gen a211=abs(a11-0.127)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f2=r(gns), r(1000) nodots: DAskat

program drop DAarbl
program DAarbl, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOarbl`n' = 0
qui replace AIOarbl`n' = 1 if AIOarbl ==`n'
qui sum AIOarbl`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.231)
gen a22=abs(a2-0.028)
gen a23=abs(a3-0.015)
gen a24=abs(a4-0.036)
gen a25=abs(a5-0.025)
gen a26=abs(a6-0.002)
gen a27=abs(a7-0.051)
gen a28=abs(a8-0.189)
gen a29=abs(a9-0.083)
gen a210=abs(a10-0.227)
gen a211=abs(a11-0.113)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f2=r(gns), r(1000) nodots: DAarbl

program drop DAecon
program DAecon, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOecon`n' = 0
qui replace AIOecon`n' = 1 if AIOecon ==`n'
qui sum AIOecon`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.216)
gen a22=abs(a2-0.066)
gen a23=abs(a3-0.028)
gen a24=abs(a4-0.009)
gen a25=abs(a5-0.028)
gen a26=abs(a6-0.004)
gen a27=abs(a7-0.051)
gen a28=abs(a8-0.285)
gen a29=abs(a9-0.028)
gen a210=abs(a10-0.181)
gen a211=abs(a11-0.102)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f2=r(gns), r(1000) nodots: DAecon

//Duncan for AIO v3//

clear

use "IO eksp data.dta"

recode ranBlock1 (1 2=.)
drop if ranBlock1==.
tab ranBlock1

program drop DAudl
program DAudl, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOudl`n' = 0
qui replace AIOudl`n' = 1 if AIOudl ==`n'
qui sum AIOudl`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.163)
gen a22=abs(a2-0.074)
gen a23=abs(a3-0.015)
gen a24=abs(a4-0.043)
gen a25=abs(a5-0.017)
gen a26=abs(a6-0.004)
gen a27=abs(a7-0.321)
gen a28=abs(a8-0.106)
gen a29=abs(a9-0.059)
gen a210=abs(a10-0.096)
gen a211=abs(a11-0.102)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f2=r(gns), r(1000) nodots: DAudl

program drop DAskat
program DAskat, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOskat`n' = 0
qui replace AIOskat`n' = 1 if AIOskat ==`n'
qui sum AIOskat`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.195)
gen a22=abs(a2-0.053)
gen a23=abs(a3-0.038)
gen a24=abs(a4-0.025)
gen a25=abs(a5-0.056)
gen a26=abs(a6-0.002)
gen a27=abs(a7-0.049)
gen a28=abs(a8-0.253)
gen a29=abs(a9-0.042)
gen a210=abs(a10-0.163)
gen a211=abs(a11-0.127)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f2=r(gns), r(1000) nodots: DAskat

program drop DAarbl
program DAarbl, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOarbl`n' = 0
qui replace AIOarbl`n' = 1 if AIOarbl ==`n'
qui sum AIOarbl`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.231)
gen a22=abs(a2-0.028)
gen a23=abs(a3-0.015)
gen a24=abs(a4-0.036)
gen a25=abs(a5-0.025)
gen a26=abs(a6-0.002)
gen a27=abs(a7-0.051)
gen a28=abs(a8-0.189)
gen a29=abs(a9-0.083)
gen a210=abs(a10-0.227)
gen a211=abs(a11-0.113)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f2=r(gns), r(1000) nodots: DAarbl

program drop DAecon
program DAecon, rclass
preserve
foreach n of numlist 1/11 {
qui gen AIOecon`n' = 0
qui replace AIOecon`n' = 1 if AIOecon ==`n'
qui sum AIOecon`n'
gen a`n' = r(mean)
sum a`n'
}
gen a21=abs(a1-0.216)
gen a22=abs(a2-0.066)
gen a23=abs(a3-0.028)
gen a24=abs(a4-0.009)
gen a25=abs(a5-0.028)
gen a26=abs(a6-0.004)
gen a27=abs(a7-0.051)
gen a28=abs(a8-0.285)
gen a29=abs(a9-0.028)
gen a210=abs(a10-0.181)
gen a211=abs(a11-0.102)
gen b =(a21+a22+a23+a24+a25+a26+a27+a28+a29+a210+a211)/2
sum b
return scalar gns = r(mean)
restore
end
bootstrap f2=r(gns), r(1000) nodots: DAecon

log close
