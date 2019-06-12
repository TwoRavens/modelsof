/* analysisNLSY.do v0.00          damiancclarke            yyyy-mm-dd:2018-06-03
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

This file takes raw data from the NLSY, and converts it into one line per child,
then runs a regression of twinning on maternal health variables conditional on
mother FEs.

*/

vers 11
clear all
set more off
cap log close

********************************************************************************
*** (1) Globals and locals
********************************************************************************
global DAT "../data"
global LOG "../log"
global OUT "../results"

cap mkdir "$OUT"
log using "$LOG/analysisNLSY.txt", text replace

********************************************************************************
*** (2) Import NLSY79 data
********************************************************************************
infile using "$DAT/NLSYyoungwomen.dct"

gen yob1 = R0494262+1900 if R0494262>0
gen yob2 = R0494266+1900 if R0494266>0
gen yob3 = R0494270+1900 if R0494270>0
gen yob4 = R0494274+1900 if R0494274>0
gen yob5 = R0494278+1900 if R0494278>0
gen yob6 = R0494282+1900 if R0494282>0
gen yob7 = R0494286+1900 if R0494286>0
gen yob8 = R0494290+1900 if R0494290>0

gen mob1 = R0494260 if R0494260>0
gen mob2 = R0494264 if R0494264>0
gen mob3 = R0494268 if R0494268>0
gen mob4 = R0494272 if R0494272>0
gen mob5 = R0494276 if R0494276>0
gen mob6 = R0494280 if R0494280>0
gen mob7 = R0494284 if R0494284>0
gen mob8 = R0494288 if R0494288>0

gen sex1 = R0494263-2 if R0494263>0
gen sex2 = R0494267-2 if R0494267>0
gen sex3 = R0494271-2 if R0494271>0
gen sex4 = R0494275-2 if R0494275>0
gen sex5 = R0494279-2 if R0494279>0
gen sex6 = R0494283-2 if R0494283>0
gen sex7 = R0494287-2 if R0494287>0
gen sex8 = R0494291-2 if R0494291>0
egen fert = rownonmiss(yob1-yob7)

gen yob1a = R0680300+1900 if R0680300>0
gen yob2a = R0681100+1900 if R0681100>0
gen yob3a = R0681900+1900 if R0681900>0
gen yob4a = R0682700+1900 if R0682700>0
gen yob5a = R0683500+1900 if R0683500>0

gen mob1a = R0680100 if R0680100>0
gen mob2a = R0680900 if R0680900>0
gen mob3a = R0681700 if R0681700>0
gen mob4a = R0682500 if R0682500>0
gen mob5a = R0683300 if R0683300>0

gen sex1a = R0680000-2 if R0680000>0
gen sex2a = R0680800-2 if R0680800>0
gen sex3a = R0681600-2 if R0681600>0
gen sex4a = R0682400-2 if R0682400>0
gen sex5a = R0683200-2 if R0683200>0

foreach vv in yob mob sex {
    gen `vv'9  = .
    gen `vv'10 = .
    gen `vv'11 = .
    gen `vv'12 = .
}
foreach f of numlist 0(1)7 {
    local val = `f'+1
    foreach num of numlist 1(1)4 {
        dis "yob`val', yob`num'a fert `f'"
        qui replace yob`val'=yob`num'a if fert == `f'
        qui replace mob`val'=mob`num'a if fert == `f'
        qui replace sex`val'=sex`num'a if fert == `f'
        local ++val
    }
}
drop yob11 yob12 mob11 mob12 sex11 sex12
drop yob1a-yob5a mob1a-mob5a sex1a-sex5a  
drop fert
egen fert = rownonmiss(yob1 yob2 yob3 yob4 yob5 yob6 yob7 yob8 yob9 yob10)

gen yob1a = R0913600+1900 if R0913600>0
gen yob2a = R0914500+1900 if R0914500>0
gen yob3a = R0915400+1900 if R0915400>0
gen yob4a = R0916300+1900 if R0916400>0

gen mob1a = R0913700 if R0913700>0
gen mob2a = R0914600 if R0914600>0
gen mob3a = R0915500 if R0915500>0
gen mob4a = R0916400 if R0916400>0

gen sex1a = R0913500-2 if R0913500>0
gen sex2a = R0914400-2 if R0914400>0
gen sex3a = R0915300-2 if R0915300>0
gen sex4a = 0


foreach vv in yob mob sex {
    gen `vv'11  = .
    gen `vv'12 = .
    gen `vv'13 = .
    gen `vv'14 = .
}
foreach f of numlist 0(1)10 {
    local val = `f'+1
    foreach num of numlist 1(1)4 {
        dis "yob`val', yob`num'a fert `f'"
        qui replace yob`val'=yob`num'a if fert == `f'
        qui replace mob`val'=mob`num'a if fert == `f'
        qui replace sex`val'=sex`num'a if fert == `f'
        local ++val
    }
}
drop yob11 yob12 yob13 yob14 mob11 mob12 mob13 mob14 sex11 sex12 sex13 sex14
drop yob1a-yob4a mob1a-mob4a sex1a-sex4a  
drop fert
egen fert = rownonmiss(yob1 yob2 yob3 yob4 yob5 yob6 yob7 yob8 yob9 yob10)

gen yob1a = R1043400+1900 if R1043400>0
gen yob2a = R1043700+1900 if R1043700>0
gen yob3a = R1044000+1900 if R1044000>0
gen yob4a = R1044300+1900 if R1044300>0

gen mob1a = R1043500 if R1043500>0
gen mob2a = R1043800 if R1043800>0
gen mob3a = R1044100 if R1044100>0
gen mob4a = R1044400 if R1044400>0

foreach vv in yob mob {
    gen `vv'11  = .
    gen `vv'12 = .
    gen `vv'13 = .
    gen `vv'14 = .
}
foreach f of numlist 0(1)10 {
    local val = `f'+1
    foreach num of numlist 1(1)4 {
        dis "yob`val', yob`num'a fert `f'"
        qui replace yob`val'=yob`num'a if fert == `f'
        qui replace mob`val'=mob`num'a if fert == `f'
        local ++val
    }
}
drop yob11 yob12 yob13 yob14 mob11 mob12 mob13 mob14
drop yob1a-yob4a mob1a-mob4a
drop fert
egen fert = rownonmiss(yob1 yob2 yob3 yob4 yob5 yob6 yob7 yob8 yob9 yob10)

gen yob1a = R1089400+1900 if R1089400>0
gen yob2a = R1089700+1900 if R1089700>0
gen yob3a = R1090000+1900 if R1090000>0
gen yob4a = R1090300+1900 if R1090300>0

gen mob1a = R1089500 if R1089500>0
gen mob2a = R1089800 if R1089800>0
gen mob3a = R1090100 if R1090100>0
gen mob4a = R1090400 if R1090400>0

foreach vv in yob mob {
    gen `vv'11  = .
    gen `vv'12 = .
    gen `vv'13 = .
    gen `vv'14 = .
}
foreach f of numlist 0(1)10 {
    local val = `f'+1
    foreach num of numlist 1(1)4 {
        dis "yob`val', yob`num'a fert `f'"
        qui replace yob`val'=yob`num'a if fert == `f'
        qui replace mob`val'=mob`num'a if fert == `f'
        local ++val
    }
}
drop yob11 yob12 yob13 yob14 mob11 mob12 mob13 mob14
drop yob1a-yob4a mob1a-mob4a
drop fert
egen fert = rownonmiss(yob1 yob2 yob3 yob4 yob5 yob6 yob7 yob8 yob9 yob10)

gen yob1a = R1339300+1900 if R1339300>0
gen yob2a = R1339600+1900 if R1339600>0
gen yob3a = R1339900+1900 if R1339900>0

gen mob1a = R1339400 if R1339400>0
gen mob2a = R1339700 if R1339700>0
gen mob3a = R1340000 if R1340000>0

foreach vv in yob mob {
    gen `vv'11  = .
    gen `vv'12 = .
    gen `vv'13 = .
}
foreach f of numlist 0(1)10 {
    local val = `f'+1
    foreach num of numlist 1(1)3 {
        dis "yob`val', yob`num'a fert `f'"
        qui replace yob`val'=yob`num'a if fert == `f'
        qui replace mob`val'=mob`num'a if fert == `f'
        local ++val
    }
}
drop yob11 yob12 yob13 mob11 mob12 mob13
drop yob1a-yob3a mob1a-mob3a
drop fert
egen fert = rownonmiss(yob1 yob2 yob3 yob4 yob5 yob6 yob7 yob8 yob9 yob10)

gen yob1a = R1438800+1900 if R1438800>0
gen yob2a = R1439200+1900 if R1439200>0
gen yob3a = R1439600+1900 if R1439600>0

gen mob1a = R1438900 if R1438900>0
gen mob2a = R1439300 if R1439300>0
gen mob3a = R1439700 if R1439700>0

foreach vv in yob mob {
    gen `vv'11  = .
    gen `vv'12 = .
    gen `vv'13 = .
}
foreach f of numlist 0(1)10 {
    local val = `f'+1
    foreach num of numlist 1(1)3 {
        dis "yob`val', yob`num'a fert `f'"
        qui replace yob`val'=yob`num'a if fert == `f'
        qui replace mob`val'=mob`num'a if fert == `f'
        local ++val
    }
}
drop yob11 yob12 yob13 mob11 mob12 mob13
drop yob1a-yob3a mob1a-mob3a
drop fert
egen fert = rownonmiss(yob1 yob2 yob3 yob4 yob5 yob6 yob7 yob8 yob9 yob10)


local yv  R5154200 R5154300 R5154400 R5154500 R5154600
local i = 1
foreach var of varlist `yv' {
    tostring `var', gen(yobS)
    gen yob`i'A = substr(yobS,-4,.)
    gen mobA2 = substr(yobS,-8,2)
    gen mobA1 = substr(yobS,-7,1)
    gen mob`i'A = mobA1
    replace mob`i'A = mobA2 if mobA2!=""
    destring yob`i'A mob`i'A, replace
    replace mob`i'A=. if yob`i'A<=1993
    replace yob`i'A=. if yob`i'A<=1993
    local ++i
    drop yobS mobA2 mobA1
}
foreach dd in yob mob {
    gen `dd'1a = `dd'1A
    replace `dd'1a = `dd'2A if `dd'1a==.
    replace `dd'1a = `dd'3A if `dd'1a==.
    replace `dd'1a = `dd'4A if `dd'1a==.
    replace `dd'1a = `dd'5A if `dd'1a==.
    gen `dd'2a = `dd'3A if `dd'2A!=.
}
foreach vv in yob mob {
    gen `vv'11  = .
    gen `vv'12 = .
}
foreach f of numlist 0(1)10 {
    local val = `f'+1
    foreach num of numlist 1(1)2 {
        dis "yob`val', yob`num'a fert `f'"
        qui replace yob`val'=yob`num'a if fert == `f'
        qui replace mob`val'=mob`num'a if fert == `f'
        local ++val
    }
}
drop yob11 yob12 mob11 mob12 yob1a yob2a mob1a mob2a
drop fert
egen fert = rownonmiss(yob1 yob2 yob3 yob4 yob5 yob6 yob7 yob8 yob9 yob10)
tab fert
hist fert, scheme(burd) freq xtitle("Fertility (Women)")
graph export "$OUT/appendix/NLSYfertility_mother.eps", replace

foreach num of numlist 1(1)10 {
    gen yob`num'x= yob`num' if yob`num'>=1968
}

egen fertx = rownonmiss(yob1x yob2x yob3x yob4x yob5x yob6x yob7x yob8x yob9x yob10x)
tab fertx


gen twin1  = yob1==yob2&mob1==mob2 if yob1!=.
gen twin2  = yob2==yob3&mob2==mob3 if yob2!=.
replace twin2 = 1 if yob2==yob1&mob2==mob1&yob2!=.
gen twin3  = yob3==yob4&mob3==mob4 if yob3!=.
replace twin3 = 1 if yob3==yob2&mob3==mob2&yob3!=.
gen twin4  = yob4==yob5&mob4==mob5 if yob4!=.
replace twin2 = 1 if yob4==yob3&mob4==mob3&yob4!=.
gen twin5  = yob5==yob6&mob5==mob6 if yob5!=.
replace twin2 = 1 if yob5==yob4&mob5==mob4&yob5!=.
gen twin6  = yob6==yob7&mob6==mob7 if yob6!=.
replace twin2 = 1 if yob6==yob5&mob6==mob5&yob6!=.
gen twin7  = yob7==yob8&mob7==mob8 if yob7!=.
replace twin2 = 1 if yob7==yob6&mob7==mob6&yob7!=.
gen twin8  = yob8==yob9&mob8==mob9 if yob8!=.
replace twin2 = 1 if yob8==yob7&mob8==mob7&yob8!=.
gen twin9  = yob9==yob10&mob9==mob10 if yob9!=.
replace twin2 = 1 if yob9==yob8&mob9==mob8&yob9!=.
gen twin10 = 0 if yob10!=.
replace twin10 = 1 if yob10==yob9&mob10==mob9&yob10!=.


reshape long yob mob sex twin, i(R0000100) j(childid)
keep if yob!=.
rename R0000100 motherid

gen age = yob-1968+R0003100
gen ageSq = age^2
xtset motherid childid
xtreg twin age ageSq i.childid, fe cluster(motherid)



keep twin age motherid childid yob mob sex fert ageSq
tempfile childPanel
save `childPanel'

infile using "$DAT/NLSYyoungwomen.dct", clear

gen weight = R0000200
gen pwt62 = R0000200
gen pwt63 = R0000200
gen pwt64 = R0000200
gen pwt65 = R0000200
gen pwt66 = R0000200
gen pwt67 = R0000200
gen pwt68 = R0000200
gen pwt69 = R0085410
gen pwt70 = R0145310
gen pwt71 = R0252510 
gen pwt72 = R0335310 
gen pwt73 = R0417110 
gen pwt74 = R0417110 
gen pwt75 = R0519510 
gen pwt76 = R0519510 
gen pwt77 = R0548310 
gen pwt78 = R0587410 
gen pwt79 = R0587410 
gen pwt80 = R0709910 
gen pwt81 = R0709910 
gen pwt82 = R0756450 
gen pwt83 = R0803250 
gen pwt84 = R0803250 
gen pwt85 = R0947320 
gen pwt86 = R0947320 
gen pwt87 = R1062820 
gen pwt88 = R1109220 
gen pwt89 = R1109220 
gen pwt90 = R1109220 
gen pwt91 = R1232720 
gen pwt92 = R1232720 
gen pwt93 = R1365220
gen pwt94 = R1365220 
gen pwt95 = R1601400
gen pwt96 = R1601400
gen pwt97 = R3498500
gen pwt98 = R3498500

gen educ62 = R0130900
gen educ63 = R0130900
gen educ64 = R0130900
gen educ65 = R0130900
gen educ66 = R0130900
gen educ67 = R0130900
gen educ68 = R0130900
gen educ69 = R0130900
gen educ70 = R0211400
gen educ71 = R0325540
gen educ72 = R0409900
gen educ73 = R0494300
gen educ74 = R0494300
gen educ75 = R0543010
gen educ76 = R0543010
gen educ77 = R0574400
gen educ78 = R0666390
gen educ79 = R0666390
gen educ80 = R0749910
gen educ81 = R0797110
gen educ82 = R0797110
gen educ83 = R0929510
gen educ84 = R1051610
gen educ85 = R1051610
gen educ86 = R1097410
gen educ87 = R1097410
gen educ88 = R1215110
gen educ89 = R1215110
gen educ90 = R1215110
gen educ91 = R1346410
gen educ92 = R1346410
gen educ93 = R1520410
gen educ94 = R1520410
gen educ95 = R3476600
gen educ96 = R3476600
gen educ97 = R4192800
gen educ98 = R4192800

gen healthLimit68 = R0032300 if R0032300>=0
gen healthLimit69 = R0032300 if R0032300>=0
gen healthLimit70 = R0190800 if R0190800>=0
gen healthLimit71 = R0296700 if R0296700>=0
gen healthLimit72 = healthLimit71
gen healthLimit73 = R0469800 if R0469800>=0
gen healthLimit74 = healthLimit73
gen healthLimit75 = R0526600 if R0526600>=0
gen healthLimit76 = healthLimit75
gen healthLimit77 = R0557200 if R0557200>=0
gen healthLimit78 = R0640800 if R0640800>=0 
gen healthLimit79 = healthLimit78
gen healthLimit80 = R0725300 if R0725300>=0 
*replace healthLimit80 = 1 if R0725400==1
gen healthLimit81 = healthLimit80
gen healthLimit82 = R0766300 if R0766300>=0
*replace healthLimit82 = 1 if R0766400==1
gen healthLimit83 = R0869900 if R0869900>=0
gen healthLimit84 = healthLimit83
gen healthLimit85 = R0958200 if R0958200>=0
*replace healthLimit85 = 1 if R0958300==1
gen healthLimit86 = healthLimit85
gen healthLimit87 = R1076800 if R1076800>=0
*replace healthLimit87 = 1 if R1076900==1
gen healthLimit88 = R1173300 if R1173300>=0
gen healthLimit89 = healthLimit88
gen healthLimit90 = healthLimit89
gen healthLimit91 = R1296500 if R1296500>=0
gen healthLimit92 = healthLimit91
gen healthLimit93 = R1467000 if R1467000>=0
gen healthLimit94 = healthLimit93
gen healthLimit95 = R3351600 if R3351600>=0
gen healthLimit96 = healthLimit95
gen healthLimit97 = R4125800 if R4125800>=0
gen healthLimit98 = healthLimit97

gen income68 = 0 if R0037000<1
replace income68 = 500 if R0037000==1
replace income68 = 1500 if R0037000==2
replace income68 = 2500 if R0037000==3
replace income68 = 3500 if R0037000==4
replace income68 = 4500 if R0037000==5
replace income68 = 5500 if R0037000==6
replace income68 = 6750 if R0037000==7
replace income68 = 8750 if R0037000==8
replace income68 = 12500 if R0037000==9
replace income68 = 20000 if R0037000==10
replace income68 = 25000 if R0037000==11
gen income69 = 0 if R0113300<1
replace income69 = 500 if R0113300==1
replace income69 = 1500 if R0113300==2
replace income69 = 2500 if R0113300==3
replace income69 = 3500 if R0113300==4
replace income69 = 4500 if R0113300==5
replace income69 = 5500 if R0113300==6
replace income69 = 6750 if R0113300==7
replace income69 = 8750 if R0113300==8
replace income69 = 12500 if R0113300==9
replace income69 = 20000 if R0113300==10
replace income69 = 25000 if R0113300==11
gen income70 = 0 if R0193100<1
replace income70 = 500 if R0193100==1
replace income70 = 1500 if R0193100==2
replace income70 = 2500 if R0193100==3
replace income70 = 3500 if R0193100==4
replace income70 = 4500 if R0193100==5
replace income70 = 5500 if R0193100==6
replace income70 = 6750 if R0193100==7
replace income70 = 8750 if R0193100==8
replace income70 = 12500 if R0193100==9
replace income70 = 20000 if R0193100==10
replace income70 = 25000 if R0193100==11
gen income71 = 0 if R0308700<1
replace income71 = 500 if R0308700==1
replace income71 = 1500 if R0308700==2
replace income71 = 2500 if R0308700==3
replace income71 = 3500 if R0308700==4
replace income71 = 4500 if R0308700==5
replace income71 = 5500 if R0308700==6
replace income71 = 6750 if R0308700==7
replace income71 = 8750 if R0308700==8
replace income71 = 12500 if R0308700==9
replace income71 = 20000 if R0308700==10
replace income71 = 25000 if R0308700==11
gen income72 = 0 if R0392500<1
replace income72 = 500 if R0392500==1
replace income72 = 1500 if R0392500==2
replace income72 = 2500 if R0392500==3
replace income72 = 3500 if R0392500==4
replace income72 = 4500 if R0392500==5
replace income72 = 5500 if R0392500==6
replace income72 = 6750 if R0392500==7
replace income72 = 8750 if R0392500==8
replace income72 = 12500 if R0392500==9
replace income72 = 20000 if R0392500==10
replace income72 = 25000 if R0392500==11
gen income73 = 0 if R0475100<1
replace income73 = 500 if R0475100==1
replace income73 = 1500 if R0475100==2
replace income73 = 2500 if R0475100==3
replace income73 = 3500 if R0475100==4
replace income73 = 4500 if R0475100==5
replace income73 = 5500 if R0475100==6
replace income73 = 6750 if R0475100==7
replace income73 = 8750 if R0475100==8
replace income73 = 12500 if R0475100==9
replace income73 = 20000 if R0475100==10
replace income73 = 25000 if R0475100==11
gen income74 = income73
gen income75 = 0 if R0533300<0
replace income75 = R0533300 if R0533300>=0
gen income76 = income75
gen income77 = 0 if R0583400<0
replace income77 = R0583400 if R0583400>=0 
gen income78 = income77
gen income79 = income78
gen income80 = income79
gen income81 = income80
gen income82 = 0 if R0796500<0
replace income82 = R0796500 if R0796500>=0 
gen income83 = 0 if R0902000<=0
replace income83 = 2000  if R0902000==1
replace income83 = 5000  if R0902000==2
replace income83 = 6750  if R0902000==3
replace income83 = 8750  if R0902000==4
replace income83 = 12500 if R0902000==5
replace income83 = 16250 if R0902000==6
replace income83 = 18750 if R0902000==7
replace income83 = 22250 if R0902000==8
replace income83 = 30000 if R0902000==9
replace income83 = 40000 if R0902000==10
replace income83 = 50000 if R0902000==11
gen income84 = income83
gen income85 = income84
gen income86 = income85
gen income87 = income86
gen income88 = 0 if R1203500<1
replace income88 = 500 if R1203500==1
replace income88 = 1500 if R1203500==2
replace income88 = 2500 if R1203500==3
replace income88 = 3500 if R1203500==4
replace income88 = 4500 if R1203500==5
replace income88 = 5500 if R1203500==6
replace income88 = 6750 if R1203500==7
replace income88 = 8750 if R1203500==8
replace income88 = 12500 if R1203500==9
replace income88 = 20000 if R1203500==10
replace income88 = 25000 if R1203500==11
foreach num of numlist 89(1)98 {
    gen income`num'=income88
}

foreach num of numlist 62(1)93 {
    gen ageYr = (1900+`num')-1968+R0003100
    tab ageYr
    gen smoke`num' = R1302400>=ageYr & R1302400>0
    replace smoke`num'=1 if R1303000>ageYr & R1303000>0
    replace smoke`num'=0 if R1302900>ageYr & R1302900>0
    drop ageYr
}
gen smoke94=smoke93
gen smoke95=R3365400==1
gen smoke96=R3365400==1
gen smoke97=R4133800==1
gen smoke98=R4133800==1


foreach num of numlist 1962(1)1998 {
    local yr = `num'-1900
    gen cancer`yr' = R6183100>=`num'
}


gen race        = R0003200
gen nationality = R0078600
gen division    = R0003600
local mvars R0000100 weight race nationality division
reshape long educ healthLimit smoke pwt cancer income, i(`mvars') j(yob)

rename R0000100 motherid
keep educ pwt yob motherid weight healthLimit smoke cancer income race nationality division
replace yob = 1900+yob
replace healthLimit = 0 if yob<1968
merge 1:m motherid yob using `childPanel'

keep if _merge==2|_merge==3
gen educSq = educ^2

xtset motherid childid
xtreg twin age ageSq i.childid, fe cluster(motherid)
gen incomeSq = income^2

local hvars healthLimit smoke cancer income incomeSq
local opts fe cluster(motherid)
local opt2 cluster(motherid)
local cond if educ!=-5&age>=18&age<=49 
local wt   [pw=weight]
bys motherid: egen pwt2 = mean(pwt)
gen bord = childid

replace twin = twin*100
replace income=income/1000

xtreg twin age ageSq i.bord i.yob `hvars'      `cond' `wt', `opts'
sum age fert twin bord age healthLimit smoke cancer if e(sample)==1

#delimit ;
estpost sum age fert twin bord age healthLimit smoke cancer if e(sample)==1;
esttab using "$OUT/appendix/NLSYsum.tex", replace label style(tex)
cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")
collabels(, none) mlabels(, none);
#delimit cr

xtreg twin age ageSq i.bord i.yob `hvars'      `cond' `wt', `opts'
foreach var of varlist healthLimit smoke cancer income educ {
    sum `var' if e(sample)==1
    replace `var'=(`var'-r(mean))/r(sd) if e(sample)==1
}

eststo: xtreg twin age ageSq i.bord i.yob `hvars'      `cond' `wt', `opts'
sum twin if e(sample)==1
local mutwin = r(mean)
estadd scalar mval = `mutwin'
eststo: xtreg twin age ageSq i.bord i.yob `hvars' educ `cond' `wt', `opts'
estadd scalar mval = `mutwin'
eststo: xtreg twin i.age     i.bord i.yob `hvars'      `cond' `wt', `opts'
estadd scalar mval = `mutwin'
eststo: xtreg twin i.age     i.bord i.yob `hvars' educ `cond' `wt', `opts'
estadd scalar mval = `mutwin'
hist fert if e(sample)==1, scheme(burd) freq xtitle("Family Size (Children)")
graph export "$OUT/appendix/NLSYfertility_children.eps", replace


lab var healthLimit "Health Limits Work"
lab var smoke       "Smoker"
lab var cancer      "Cancer Diagnosis"
lab var income      "Income in 1000s"
lab var incomeSq    "Income Squared"
lab var age         "Age at Birth"
lab var ageSq       "Age at Birth Squared"
lab var educ        "Education"

#delimit ;
esttab est1 est2 est3 est4 using "$OUT/appendix/NLSYPanel.tex", replace 
b(%-9.3f) se(%-9.3f) starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
keep(healthLimit smoke cancer income incomeSq age ageSq educ)
stats(mval N N_g, fmt(%9.3f %9.0gc)
      label("Mean Dependent Variable" "Number of Children" "Number of Mothers"))
label nonotes mlabels(, none) nonumbers style(tex) fragment noline;
#delimit cr
#delimit ;
esttab est3 using "$OUT/appendix/NLSYPanel.tex", replace  b(%-9.3f) se(%-9.3f)
starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
keep(healthLimit smoke cancer) stats(mval N N_g, fmt(%9.3f %9.0gc)
      label("Mean Dependent Variable" "Number of Children" "Number of Mothers"))
label nonotes mlabels(, none) nonumbers style(tex) fragment noline;
#delimit cr
estimates clear

log close
