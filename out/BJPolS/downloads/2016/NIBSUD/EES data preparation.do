cd "/your/local/directory"

use "ees2009_v0.9_20110622.dta", clear

gen eu15=0
replace eu15=1 if t102==1040
replace eu15=1 if t102==1056
replace eu15=1 if t102==1276
replace eu15=1 if t102==1208
replace eu15=1 if t102==1300
replace eu15=1 if t102==1724
replace eu15=1 if t102==1246
replace eu15=1 if t102==1250
replace eu15=1 if t102==1372
replace eu15=1 if t102==1380
replace eu15=1 if t102==1442
replace eu15=1 if t102==1528
replace eu15=1 if t102==1620
replace eu15=1 if t102==1752
replace eu15=1 if t102==1826
drop if eu15 != 1

gen id=_n

gen lr=q46 if q46<11
gen eu=q80 if q80<11
gen lrcen=lr-5
gen eucen=eu-5

forvalues x= 1/15 {
gen ptv`x'=q39_p`x' if q39_p`x'<11
gen lrparty`x'=q47_p`x' if q47_p`x'<11
gen euparty`x'=q81_p`x' if q81_p`x'<11
gen lr`x'cen=lrparty`x'-5
gen eu`x'cen=euparty`x'-5
gen lr`x'proxsq=(lr`x'cen-lrcen)^2
gen eu`x'proxsq=(eu`x'cen-eucen)^2
gen lr`x'proxabs=abs(lr`x'cen-lrcen)
gen eu`x'proxabs=abs(eu`x'cen-eucen)
gen eu`x'sq=eu`x'cen^2
gen lr`x'sq=lr`x'cen^2
}
gen NPvote = . local i = 0foreach x of numlist 1040320 1040520 1040720 1040700 1040110 1040951 1040422 1040220 1040490 {local i = `i' + 1replace NPvote = `i' if t102 == 1040 & q27 == `x'}local i = 0foreach x of numlist 1056521 1056421 1056327 1056711 1056112 1056913 1056600 1056328 1056222 1056522 1056427 1056322 1056710 1056111 1056522 {local i = `i' + 1replace NPvote = `i' if t102 == 1056 & q27 == `x'}local i = 0foreach x of numlist 1100300 1100400 1100900 1100700 1100600 1100001 1100002 1100601 1100090 1100190 1100790    {local i = `i' + 1replace NPvote = `i' if t102 == 1100 & q27 == `x'}local i = 0foreach x of numlist 1196321 1196711 1196422 1196322 1196600 1196110  {local i = `i' + 1replace NPvote = `i' if t102 == 1196 & q27 == `x'}local i = 0foreach x of numlist 1203320 1203523 1203220 1203413 1203110 1203590 {local i = `i' + 1replace NPvote = `i' if t102 == 1203 & q27 == `x'}local i = 0foreach x of numlist 1276521 1276320 1276113 1276321 1276420 1276090 1276091 1276092 1276190 1276191 1276290 1276590 1276790   {local i = `i' + 1replace NPvote = `i' if t102 == 1276 & q27 == `x'}local i = 0foreach x of numlist 1208320 1208410 1208620 1208330 1208720 1208420 1208421 1208055 1208054 1208290 1208490 1208590   {local i = `i' + 1replace NPvote = `i' if t102 == 1208 & q27 == `x'}local i = 0foreach x of numlist 1233430 1233411 1233613 1233410 1233100 1233612 1230090 1233001 1233002 1233003 1233300 1233431 1233510   {local i = `i' + 1replace NPvote = `i' if t102 == 1233 & q27 == `x'}local i = 0foreach x of numlist 1300511 1300313 1300210 1300215 1300703 1300116  {local i = `i' + 1replace NPvote = `i' if t102 == 1300 & q27 == `x'}local i = 0foreach x of numlist 1724610 1724320 1724220 0 1724010 1724007 1724905 1724902 0 1724908 0 1724907 1724923 1724903 1724922 {local i = `i' + 1replace NPvote = `i' if t102 == 1724 & q27 == `x'}local i = 0foreach x of numlist 1246320 1246810 1246620 1246223 1246110 1246901 1246520 1246820 {local i = `i' + 1replace NPvote = `i' if t102 == 1246 & q27 == `x'}local i = 0foreach x of numlist 1250226 1250220 1250320 1250110 1250336 1250626 1250720 1250337 1250090 1250190     {local i = `i' + 1replace NPvote = `i' if t102 == 1250 & q27 == `x'}local i = 0foreach x of numlist 1348421 1348700 0 1348210 0 1348521 1348220 1348422 1348526       {local i = `i' + 1replace NPvote = `i' if t102 == 1348 & q27 == `x'}local i = 0foreach x of numlist 1372620 1372520 1372110 1372320 1372951 1372001 1372000 1372490   {local i = `i' + 1replace NPvote = `i' if t102 == 1372 & q27 == `x'}local i = 0foreach x of numlist 1380630 1380720 1380331 1380902 1380523 1380212 1380007 1380631 1380090 1380190 1380290 1380690 1380790   {local i = `i' + 1replace NPvote = `i' if t102 == 1380 & q27 == `x'}local i = 0foreach x of numlist 1440620 1440320 1440001 1440021 1440421 1440322 1440420 1440952 1440824 1440410 1440490 1440922 {local i = `i' + 1replace NPvote = `i' if t102 == 1440 & q27 == `x'}local i = 0foreach x of numlist 1442113 1442320 1442420 1442520 1442951 1442222 1442220 1442009    {local i = `i' + 1replace NPvote = `i' if t102 == 1442 & q27 == `x'}local i = 0foreach x of numlist 1428610 1428110 1428423 1428317 1428424 1428723 1428422 1428611 1428425    {local i = `i' + 1replace NPvote = `i' if t102 == 1428 & q27 == `x'}local i = 0foreach x of numlist 1470500 1470300 1470100 1470700   {local i = `i' + 1replace NPvote = `i' if t102 == 1470 & q27 == `x'}local i = 0foreach x of numlist 1528320 1528521 1528420 1528330 1528110 1528006 1528526 1528527 1528220 1528600 1528726 1528790 {local i = `i' + 1replace NPvote = `i' if t102 == 1528 & q27 == `x'}local i = 0foreach x of numlist 0 1616811 0 0 1616010 1616011 1616210 0 1616435 1616436  {local i = `i' + 1replace NPvote = `i' if t102 == 1616 & q27 == `x'}local i = 0foreach x of numlist 1620211 1620314 1620229 1620311 1620313 1620190 1620290 1620590  {local i = `i' + 1replace NPvote = `i' if t102 == 1620 & q27 == `x'}local i = 0foreach x of numlist 1642400 1642300 1642401 1642900 1642600 1642800 1642700 1642290   {local i = `i' + 1replace NPvote = `i' if t102 == 1642 & q27 == `x'}local i = 0foreach x of numlist 1752220 1752320 1752810 1752420 1752620 1752520 1752110 1752700  {local i = `i' + 1replace NPvote = `i' if t102 == 1752 & q27 == `x'}local i = 0foreach x of numlist 1705951 1705421 1705521 1705710 1705320 1705323 1705324 1705522 1705952 1705090 1705790  {local i = `i' + 1replace NPvote = `i' if t102 == 1705 & q27 == `x'}local i = 0foreach x of numlist 1703711 1703423 1703523 1703954 1703521 1703710 1703222 1703524 1703190 1703390 1703690  {local i = `i' + 1replace NPvote = `i' if t102 == 1703 & q27 == `x'}local i = 0foreach x of numlist 1826320 1826620 1826421 1826902 1826901 1826951 1826720 1826110 1826090 1826390 1826391 1826392 {local i = `i' + 1replace NPvote = `i' if t102 == 1826 & q27 == `x'}forvalues x= 1/15 {gen votedNP`x'= 0 if NPvote < .replace votedNP`x'=1 if NPvote == `x'}
*** Stacking:
expand 15
bysort id: gen stack=_n

gen votedNP=votedNP1 if stack==1gen lrparty=lrparty1 if stack==1
gen euparty=euparty1 if stack==1
gen ptv=ptv1 if stack==1
gen lrproxsq=lr1proxsq if stack==1
gen lrproxabs=lr1proxabs if stack==1
gen euproxsq=eu1proxsq if stack==1
gen euproxabs=eu1proxabs if stack==1
gen lrprtycen=lr1cen if stack==1
gen euprtycen=eu1cen if stack==1

forvalues x= 2/15 {
replace votedNP=votedNP`x' if stack==`x'
drop votedNP`x'
replace lrparty=lrparty`x' if stack==`x'
replace euparty=euparty`x' if stack==`x'
replace ptv=ptv`x' if stack==`x'
replace lrproxsq=lr`x'proxsq if stack==`x'
replace lrproxabs=lr`x'proxabs if stack==`x'
replace euproxsq=eu`x'proxsq if stack==`x'
replace euproxabs=eu`x'proxabs if stack==`x'
replace lrprtycen=lr`x'cen if stack==`x'
replace euprtycen=lr`x'cen if stack==`x'
} 

gen lrpartysq=lrparty^2
gen eupartysq=euparty^2
gen lrprtycensq=lrprtycen^2
gen euprtycensq=euprtycen^2
gen lrdir=lrprtycen*lrcen
gen eudir=euprtycen*eucen

gen lrsameside=0
replace lrsameside=1 if lrdir>0
replace lrsameside=1 if lrdir==.

gen lroppside=0
replace lroppside=1 if lrdir<0
replace lroppside=1 if lrdir==.
gen lropposite=lroppside

gen eusameside=0
replace eusameside=1 if eudir>0
replace eusameside=1 if eudir==.

gen euoppside=0
replace euoppside=1 if eudir<0
replace euoppside=1 if eudir==.

gen lrch=.
gen votechoice=0

replace lrch=6.818 if t102==1300 &  stack==1
replace lrch=4.36 if t102==1300  &  stack==2
replace lrch=0.36 if t102==1300  &  stack==3
replace lrch=1.54 if t102==1300  &  stack==4
replace lrch=8.81 if t102==1300  &  stack==5
replace lrch=2.25 if t102==1300  &  stack==6

replace votechoice=1 if t102==1300 & stack==1 & q28==1300511
replace votechoice=1 if t102==1300 & stack==2 & q28==1300313
replace votechoice=1 if t102==1300 & stack==3 & q28==1300210
replace votechoice=1 if t102==1300 & stack==4 & q28==1300215
replace votechoice=1 if t102==1300 & stack==5 & q28==1300703
replace votechoice=1 if t102==1300 & stack==6 & q28==1300116

*replace lrch= if t102==1250 &  stack==1
replace lrch=1.11 if t102==1250 &  stack==2
replace lrch=2.77 if t102==1250 &  stack==3
replace lrch=2.55 if t102==1250 &  stack==4
replace lrch=5.11 if t102==1250 &  stack==5
replace lrch=7.22 if t102==1250 &  stack==6
replace lrch=9.88 if t102==1250 &  stack==7
replace lrch=3.625 if t102==1250 &  stack==8

replace votechoice=1 if t102==1250 & stack==1 & q28==1250226
replace votechoice=1 if t102==1250 & stack==2 & q28==1250220
replace votechoice=1 if t102==1250 & stack==3 & q28==1250320
replace votechoice=1 if t102==1250 & stack==4 & q28==1250110
replace votechoice=1 if t102==1250 & stack==5 & q28==1250336
replace votechoice=1 if t102==1250 & stack==6 & q28==1250626
replace votechoice=1 if t102==1250 & stack==7 & q28==1250720
replace votechoice=1 if t102==1250 & stack==8 & q28==1250337

replace lrch=6.125 if t102==1276 &  stack==1
replace lrch=3.625 if t102==1276 &  stack==2
replace lrch=3.625 if t102==1276 &  stack==3
replace lrch=1.312 if t102==1276 &  stack==4
replace lrch=6.599 if t102==1250 &  stack==5

replace votechoice=1 if t102==1276 & stack==1 & q28==1276521
replace votechoice=1 if t102==1276 & stack==2 & q28==1276320
replace votechoice=1 if t102==1276 & stack==3 & q28==1276113
replace votechoice=1 if t102==1276 & stack==4 & q28==1276321
replace votechoice=1 if t102==1276 & stack==5 & q28==1276420

replace lrch=4 if t102==1826 &  stack==1
replace lrch=7.13 if t102==1826 &  stack==2
replace lrch=5 if t102==1826 &  stack==3
replace lrch=3.33 if t102==1826 &  stack==4
replace lrch=3 if t102==1826 &  stack==5
replace lrch=8.78 if t102==1826 &  stack==6
replace lrch=9.928 if t102==1826 &  stack==7
replace lrch=2.53 if t102==1826 &  stack==8

replace votechoice=1 if t102==1826 & stack==1 & q28==1826320
replace votechoice=1 if t102==1826 & stack==2 & q28==1826620
replace votechoice=1 if t102==1826 & stack==3 & q28==1826421
replace votechoice=1 if t102==1826 & stack==4 & q28==1826902
replace votechoice=1 if t102==1826 & stack==5 & q28==1826901
replace votechoice=1 if t102==1826 & stack==6 & q28==1826951
replace votechoice=1 if t102==1826 & stack==7 & q28==1826720
replace votechoice=1 if t102==1826 & stack==8 & q28==1826110

replace lrch=. if t102==1620 &  stack==1
replace lrch=8 if t102==1620 &  stack==2
replace lrch=0.66 if t102==1620 &  stack==3
replace lrch=4.16 if t102==1620 &  stack==4
replace lrch=6.66 if t102==1620 &  stack==5

replace votechoice=1 if t102==1620 & stack==1 & q28==1620211
replace votechoice=1 if t102==1620 & stack==2 & q28==1620314
replace votechoice=1 if t102==1620 & stack==3 & q28==1620229
replace votechoice=1 if t102==1620 & stack==4 & q28==1620311
replace votechoice=1 if t102==1620 & stack==5 & q28==1620313

replace lrch=1.428 if t102==1752 &  stack==1
replace lrch=3.28 if t102==1752 &  stack==2
replace lrch=7 if t102==1752 &  stack==3
replace lrch=7.07 if t102==1752 &  stack==4
replace lrch=7.285 if t102==1752 &  stack==5
replace lrch=7.0714 if t102==1752 &  stack==6
replace lrch=3.5 if t102==1752 &  stack==7
replace lrch=8.3846 if t102==1752 &  stack==8
replace lrch=5.111 if t102==1752 &  stack==9

replace votechoice=1 if t102==1752 & stack==1 & q28==1752220
replace votechoice=1 if t102==1752 & stack==2 & q28==1752320
replace votechoice=1 if t102==1752 & stack==3 & q28==1752810
replace votechoice=1 if t102==1752 & stack==4 & q28==1752420
replace votechoice=1 if t102==1752 & stack==5 & q28==1752620
replace votechoice=1 if t102==1752 & stack==6 & q28==1752520
replace votechoice=1 if t102==1752 & stack==7 & q28==1752110
replace votechoice=1 if t102==1752 & stack==8 & q28==1752700
replace votechoice=1 if t102==1752 & stack==9 & q28==1752000

replace lrch=7.25 if t102==1372 &  stack==1
replace lrch=7.25 if t102==1372 &  stack==2
replace lrch=3.5 if t102==1372 &  stack==3
replace lrch=3.875 if t102==1372 &  stack==4
replace lrch=2.125 if t102==1372 &  stack==5
replace lrch=. if t102==1372 &  stack==6

replace votechoice=1 if t102==1372 & stack==1 & q28==1372620
replace votechoice=1 if t102==1372 & stack==2 & q28==1372520
replace votechoice=1 if t102==1372 & stack==3 & q28==1372110
replace votechoice=1 if t102==1372 & stack==4 & q28==1372320
replace votechoice=1 if t102==1372 & stack==5 & q28==1372951
replace votechoice=1 if t102==1372 & stack==6 & q28==1372001

replace lrch=8 if t102==1380 &  stack==1
replace lrch=8.55 if t102==1380 &  stack==2
replace lrch=3.22 if t102==1380 &  stack==3
replace lrch=4 if t102==1380 &  stack==4
replace lrch=5.33 if t102==1380 &  stack==5
replace lrch=0.84 if t102==1380 &  stack==6
replace lrch=. if t102==1380 &  stack==7
replace lrch=. if t102==1380 &  stack==8

replace votechoice=1 if t102==1380 & stack==1 & q28==1380630
replace votechoice=1 if t102==1380 & stack==2 & q28==1380720
replace votechoice=1 if t102==1380 & stack==3 & q28==1380331
replace votechoice=1 if t102==1380 & stack==4 & q28==1380902
replace votechoice=1 if t102==1380 & stack==5 & q28==1380523
replace votechoice=1 if t102==1380 & stack==6 & q28==1380212
replace votechoice=1 if t102==1380 & stack==7 & q28==1380007
replace votechoice=1 if t102==1380 & stack==8 & q28==1380631

replace lrch=4.18 if t102==1208 &  stack==1
replace lrch=5.18 if t102==1208 &  stack==2
replace lrch=7.54 if t102==1208 &  stack==3
replace lrch=2.81 if t102==1208 &  stack==4
replace lrch=7.81 if t102==1208 &  stack==5
replace lrch=8.19 if t102==1208 &  stack==6
replace lrch=8.19 if t102==1208 &  stack==7
replace lrch=3.17 if t102==1208 &  stack==8
replace lrch=2.66 if t102==1208 &  stack==9

replace votechoice=1 if t102==1208 & stack==1 & q28==1208320
replace votechoice=1 if t102==1208 & stack==2 & q28==1208410
replace votechoice=1 if t102==1208 & stack==3 & q28==1208620
replace votechoice=1 if t102==1208 & stack==4 & q28==1208230
replace votechoice=1 if t102==1208 & stack==5 & q28==1208720
replace votechoice=1 if t102==1208 & stack==6 & q28==1208420
replace votechoice=1 if t102==1208 & stack==7 & q28==1208421
replace votechoice=1 if t102==1208 & stack==8 & q28==1208955
replace votechoice=1 if t102==1208 & stack==9 & q28==1208954

replace lrch=3.357 if t102==1040 &  stack==1
replace lrch=7.07 if t102==1040 &  stack==2
replace lrch=8.928 if t102==1040 &  stack==3
replace lrch=8.28 if t102==1040 &  stack==4
replace lrch=2.285 if t102==1040 &  stack==5
replace lrch=4.77 if t102==1040 &  stack==6
replace lrch=4.4 if t102==1040 &  stack==7
replace lrch=. if t102==1040 &  stack==8

replace votechoice=1 if t102==1040 & stack==1 & q28==1040320
replace votechoice=1 if t102==1040 & stack==2 & q28==1040520
replace votechoice=1 if t102==1040 & stack==3 & q28==1040420
replace votechoice=1 if t102==1040 & stack==4 & q28==1040600
replace votechoice=1 if t102==1040 & stack==5 & q28==1040110
replace votechoice=1 if t102==1040 & stack==6 & q28==1040951
replace votechoice=1 if t102==1040 & stack==7 & q28==1040422
replace votechoice=1 if t102==1040 & stack==8 & q28==1040220

replace lrch=. if t102==1442 &  stack==1
replace lrch=. if t102==1442 &  stack==2
replace lrch=. if t102==1442 &  stack==3
replace lrch=. if t102==1442 &  stack==4
replace lrch=. if t102==1442 &  stack==5
replace lrch=. if t102==1442 &  stack==6
replace lrch=. if t102==1442 &  stack==7
replace lrch=. if t102==1442 &  stack==8

replace votechoice=1 if t102==1442 & stack==1 & q28==1442113
replace votechoice=1 if t102==1442 & stack==2 & q28==1442320
replace votechoice=1 if t102==1442 & stack==3 & q28==1442420
replace votechoice=1 if t102==1442 & stack==4 & q28==1442520
replace votechoice=1 if t102==1442 & stack==5 & q28==1442951
replace votechoice=1 if t102==1442 & stack==6 & q28==1442222
replace votechoice=1 if t102==1442 & stack==7 & q28==1442220
replace votechoice=1 if t102==1442 & stack==8 & q28==1442009

replace lrch=4 if t102==1246 &  stack==1
replace lrch=5.699 if t102==1246 &  stack==2
replace lrch=7.5 if t102==1246 &  stack==3
replace lrch=2.2 if t102==1246 &  stack==4
replace lrch=4.5999 if t102==1246 &  stack==5
replace lrch=6.8 if t102==1246 &  stack==6
replace lrch=6.59 if t102==1246 &  stack==7
replace lrch=5.4 if t102==1246 &  stack==8

replace votechoice=1 if t102==1246 & stack==1 & q28==1246320
replace votechoice=1 if t102==1246 & stack==2 & q28==1246810
replace votechoice=1 if t102==1246 & stack==3 & q28==1246620
replace votechoice=1 if t102==1246 & stack==4 & q28==1246223
replace votechoice=1 if t102==1246 & stack==5 & q28==1246110
replace votechoice=1 if t102==1246 & stack==6 & q28==1246901
replace votechoice=1 if t102==1246 & stack==7 & q28==1246520
replace votechoice=1 if t102==1246 & stack==8 & q28==1246820

replace lrch=3.857 if t102==1528 &  stack==1
replace lrch=6.285 if t102==1528 &  stack==2
replace lrch=7.857 if t102==1528 &  stack==3
replace lrch=5 if t102==1528 &  stack==4
replace lrch=2.571 if t102==1528 &  stack==5
replace lrch=3.36 if t102==1528 &  stack==6
replace lrch=5.357 if t102==1528 &  stack==7
replace lrch=7.7857 if t102==1528 &  stack==8
replace lrch=1.6428 if t102==1528 &  stack==9
replace lrch=8.6153 if t102==1528 &  stack==10
replace lrch=. if t102==1528 &  stack==11

replace votechoice=1 if t102==1528 & stack==1 & q28==1528320
replace votechoice=1 if t102==1528 & stack==2 & q28==1528521
replace votechoice=1 if t102==1528 & stack==3 & q28==1528420
replace votechoice=1 if t102==1528 & stack==4 & q28==1528330
replace votechoice=1 if t102==1528 & stack==5 & q28==1528110
replace votechoice=1 if t102==1528 & stack==6 & q28==1528006
replace votechoice=1 if t102==1528 & stack==7 & q28==1528526
replace votechoice=1 if t102==1528 & stack==8 & q28==1528527
replace votechoice=1 if t102==1528 & stack==9 & q28==1528220
replace votechoice=1 if t102==1528 & stack==10 & q28==1528600
replace votechoice=1 if t102==1528 & stack==11 & q28==1528726

replace lrch=5.7857 if t102==1056 &  stack==1
replace lrch=6.928 if t102==1056 &  stack==2
replace lrch=3.428 if t102==1056 &  stack==3
replace lrch=9.857 if t102==1056 &  stack==4
replace lrch=2.285 if t102==1056 &  stack==5
replace lrch=7.57 if t102==1056 &  stack==6
replace lrch=8.428 if t102==1056 &  stack==7
replace lrch=2.769 if t102==1056 &  stack==8
replace lrch=0.2857 if t102==1056 &  stack==9
replace lrch=4.5 if t102==1056 &  stack==10
replace lrch=7 if t102==1056 &  stack==11
replace lrch=2.5 if t102==1056 &  stack==12
replace lrch=9.214 if t102==1056 &  stack==13
replace lrch=2.2857 if t102==1056 &  stack==14

replace votechoice=1 if t102==1056 & stack==1 & q28==1056521
replace votechoice=1 if t102==1056 & stack==2 & q28==1056421
replace votechoice=1 if t102==1056 & stack==3 & q28==1056327
replace votechoice=1 if t102==1056 & stack==4 & q28==1056711
replace votechoice=1 if t102==1056 & stack==5 & q28==1056112
replace votechoice=1 if t102==1056 & stack==6 & q28==1056913
replace votechoice=1 if t102==1056 & stack==7 & q28==1056600
replace votechoice=1 if t102==1056 & stack==8 & q28==1056328
replace votechoice=1 if t102==1056 & stack==9 & q28==1056222
replace votechoice=1 if t102==1056 & stack==10 & q28==1056522
replace votechoice=1 if t102==1056 & stack==11 & q28==1056427
replace votechoice=1 if t102==1056 & stack==12 & q28==1056322
replace votechoice=1 if t102==1056 & stack==13 & q28==1056710
replace votechoice=1 if t102==1056 & stack==14 & q28==1056111

replace lrch=7.33 if t102==1724 &  stack==1
replace lrch=3.66 if t102==1724 &  stack==2
replace lrch=1.83 if t102==1724 &  stack==3
replace lrch=5.54 if t102==1724 &  stack==5
replace lrch=6 if t102==1724 &  stack==6
replace lrch=3 if t102==1724 &  stack==7
replace lrch=6.08 if t102==1724 &  stack==8
replace lrch=2.36 if t102==1724 &  stack==9
replace lrch=6.18 if t102==1724 &  stack==10
replace lrch=. if t102==1724 &  stack==11
replace lrch=4 if t102==1724 &  stack==12
replace lrch=. if t102==1724 &  stack==13

replace votechoice=1 if t102==1724 & stack==1 & q28==1724610
replace votechoice=1 if t102==1724 & stack==2 & q28==1724320
replace votechoice=1 if t102==1724 & stack==3 & q28==1724220
replace votechoice=1 if t102==1724 & stack==5 & q28==1724010
replace votechoice=1 if t102==1724 & stack==6 & q28==1724007
replace votechoice=1 if t102==1724 & stack==7 & q28==1724905
replace votechoice=1 if t102==1724 & stack==8 & q28==1724902
replace votechoice=1 if t102==1724 & stack==9 & q28==1724908
replace votechoice=1 if t102==1724 & stack==10 & q28==1724907
replace votechoice=1 if t102==1724 & stack==11 & q28==1724923
replace votechoice=1 if t102==1724 & stack==12 & q28==1724903
replace votechoice=1 if t102==1724 & stack==13 & q28==1724922

replace votechoice=. if q28<100

gen voterec=0

replace voterec=1 if t102==1300 & stack==1 & q27==1300511
replace voterec=1 if t102==1300 & stack==2 & q27==1300313
replace voterec=1 if t102==1300 & stack==3 & q27==1300210
replace voterec=1 if t102==1300 & stack==4 & q27==1300215
replace voterec=1 if t102==1300 & stack==5 & q27==1300703
replace voterec=1 if t102==1300 & stack==6 & q27==1300116

replace voterec=1 if t102==1250 & stack==1 & q27==1250226
replace voterec=1 if t102==1250 & stack==2 & q27==1250220
replace voterec=1 if t102==1250 & stack==3 & q27==1250320
replace voterec=1 if t102==1250 & stack==4 & q27==1250110
replace voterec=1 if t102==1250 & stack==5 & q27==1250336
replace voterec=1 if t102==1250 & stack==6 & q27==1250626
replace voterec=1 if t102==1250 & stack==7 & q27==1250720
replace voterec=1 if t102==1250 & stack==8 & q27==1250337

replace voterec=1 if t102==1276 & stack==1 & q27==1276521
replace voterec=1 if t102==1276 & stack==2 & q27==1276320
replace voterec=1 if t102==1276 & stack==3 & q27==1276113
replace voterec=1 if t102==1276 & stack==4 & q27==1276321
replace voterec=1 if t102==1276 & stack==5 & q27==1276420

replace voterec=1 if t102==1826 & stack==1 & q27==1826320
replace voterec=1 if t102==1826 & stack==2 & q27==1826620
replace voterec=1 if t102==1826 & stack==3 & q27==1826421
replace voterec=1 if t102==1826 & stack==4 & q27==1826902
replace voterec=1 if t102==1826 & stack==5 & q27==1826901
replace voterec=1 if t102==1826 & stack==6 & q27==1826951
replace voterec=1 if t102==1826 & stack==7 & q27==1826720
replace voterec=1 if t102==1826 & stack==8 & q27==1826110

replace voterec=1 if t102==1620 & stack==1 & q27==1620211
replace voterec=1 if t102==1620 & stack==2 & q27==1620314
replace voterec=1 if t102==1620 & stack==3 & q27==1620229
replace voterec=1 if t102==1620 & stack==4 & q27==1620311
replace voterec=1 if t102==1620 & stack==5 & q27==1620313

replace voterec=1 if t102==1752 & stack==1 & q27==1752220
replace voterec=1 if t102==1752 & stack==2 & q27==1752320
replace voterec=1 if t102==1752 & stack==3 & q27==1752810
replace voterec=1 if t102==1752 & stack==4 & q27==1752420
replace voterec=1 if t102==1752 & stack==5 & q27==1752620
replace voterec=1 if t102==1752 & stack==6 & q27==1752520
replace voterec=1 if t102==1752 & stack==7 & q27==1752110
replace voterec=1 if t102==1752 & stack==8 & q27==1752700
replace voterec=1 if t102==1752 & stack==9 & q27==1752000

replace voterec=1 if t102==1372 & stack==1 & q27==1372620
replace voterec=1 if t102==1372 & stack==2 & q27==1372520
replace voterec=1 if t102==1372 & stack==3 & q27==1372110
replace voterec=1 if t102==1372 & stack==4 & q27==1372320
replace voterec=1 if t102==1372 & stack==5 & q27==1372951
replace voterec=1 if t102==1372 & stack==6 & q27==1372001

replace voterec=1 if t102==1380 & stack==1 & q27==1380630
replace voterec=1 if t102==1380 & stack==2 & q27==1380720
replace voterec=1 if t102==1380 & stack==3 & q27==1380331
replace voterec=1 if t102==1380 & stack==4 & q27==1380902
replace voterec=1 if t102==1380 & stack==5 & q27==1380523
replace voterec=1 if t102==1380 & stack==6 & q27==1380212
replace voterec=1 if t102==1380 & stack==7 & q27==1380007
replace voterec=1 if t102==1380 & stack==8 & q27==1380631

replace voterec=1 if t102==1208 & stack==1 & q27==1208320
replace voterec=1 if t102==1208 & stack==2 & q27==1208410
replace voterec=1 if t102==1208 & stack==3 & q27==1208620
replace voterec=1 if t102==1208 & stack==4 & q27==1208230
replace voterec=1 if t102==1208 & stack==5 & q27==1208720
replace voterec=1 if t102==1208 & stack==6 & q27==1208420
replace voterec=1 if t102==1208 & stack==7 & q27==1208421
replace voterec=1 if t102==1208 & stack==8 & q27==1208955
replace voterec=1 if t102==1208 & stack==9 & q27==1208954

replace voterec=1 if t102==1040 & stack==1 & q27==1040320
replace voterec=1 if t102==1040 & stack==2 & q27==1040520
replace voterec=1 if t102==1040 & stack==3 & q27==1040420
replace voterec=1 if t102==1040 & stack==4 & q27==1040600
replace voterec=1 if t102==1040 & stack==5 & q27==1040110
replace voterec=1 if t102==1040 & stack==6 & q27==1040951
replace voterec=1 if t102==1040 & stack==7 & q27==1040422
replace voterec=1 if t102==1040 & stack==8 & q27==1040220

replace voterec=1 if t102==1442 & stack==1 & q27==1442113
replace voterec=1 if t102==1442 & stack==2 & q27==1442320
replace voterec=1 if t102==1442 & stack==3 & q27==1442420
replace voterec=1 if t102==1442 & stack==4 & q27==1442520
replace voterec=1 if t102==1442 & stack==5 & q27==1442951
replace voterec=1 if t102==1442 & stack==6 & q27==1442222
replace voterec=1 if t102==1442 & stack==7 & q27==1442220
replace voterec=1 if t102==1442 & stack==8 & q27==1442009

replace voterec=1 if t102==1246 & stack==1 & q27==1246320
replace voterec=1 if t102==1246 & stack==2 & q27==1246810
replace voterec=1 if t102==1246 & stack==3 & q27==1246620
replace voterec=1 if t102==1246 & stack==4 & q27==1246223
replace voterec=1 if t102==1246 & stack==5 & q27==1246110
replace voterec=1 if t102==1246 & stack==6 & q27==1246901
replace voterec=1 if t102==1246 & stack==7 & q27==1246520
replace voterec=1 if t102==1246 & stack==8 & q27==1246820

replace voterec=1 if t102==1528 & stack==1 & q27==1528320
replace voterec=1 if t102==1528 & stack==2 & q27==1528521
replace voterec=1 if t102==1528 & stack==3 & q27==1528420
replace voterec=1 if t102==1528 & stack==4 & q27==1528330
replace voterec=1 if t102==1528 & stack==5 & q27==1528110
replace voterec=1 if t102==1528 & stack==6 & q27==1528006
replace voterec=1 if t102==1528 & stack==7 & q27==1528526
replace voterec=1 if t102==1528 & stack==8 & q27==1528527
replace voterec=1 if t102==1528 & stack==9 & q27==1528220
replace voterec=1 if t102==1528 & stack==10 & q27==1528600
replace voterec=1 if t102==1528 & stack==11 & q27==1528726

replace voterec=1 if t102==1056 & stack==1 & q27==1056521
replace voterec=1 if t102==1056 & stack==2 & q27==1056421
replace voterec=1 if t102==1056 & stack==3 & q27==1056327
replace voterec=1 if t102==1056 & stack==4 & q27==1056711
replace voterec=1 if t102==1056 & stack==5 & q27==1056112
replace voterec=1 if t102==1056 & stack==6 & q27==1056913
replace voterec=1 if t102==1056 & stack==7 & q27==1056600
replace voterec=1 if t102==1056 & stack==8 & q27==1056328
replace voterec=1 if t102==1056 & stack==9 & q27==1056222
replace voterec=1 if t102==1056 & stack==10 & q27==1056522
replace voterec=1 if t102==1056 & stack==11 & q27==1056427
replace voterec=1 if t102==1056 & stack==12 & q27==1056322
replace voterec=1 if t102==1056 & stack==13 & q27==1056710
replace voterec=1 if t102==1056 & stack==14 & q27==1056111

replace voterec=1 if t102==1724 & stack==1 & q27==1724610
replace voterec=1 if t102==1724 & stack==2 & q27==1724320
replace voterec=1 if t102==1724 & stack==3 & q27==1724220
replace voterec=1 if t102==1724 & stack==5 & q27==1724010
replace voterec=1 if t102==1724 & stack==6 & q27==1724007
replace voterec=1 if t102==1724 & stack==7 & q27==1724905
replace voterec=1 if t102==1724 & stack==8 & q27==1724902
replace voterec=1 if t102==1724 & stack==9 & q27==1724908
replace voterec=1 if t102==1724 & stack==10 & q27==1724907
replace voterec=1 if t102==1724 & stack==11 & q27==1724923
replace voterec=1 if t102==1724 & stack==12 & q27==1724903
replace voterec=1 if t102==1724 & stack==13 & q27==1724922

replace voterec=. if q27<100


gen pid=0

replace pid=1 if t102==1300 & stack==1 & q87==1300511
replace pid=1 if t102==1300 & stack==2 & q87==1300313
replace pid=1 if t102==1300 & stack==3 & q87==1300210
replace pid=1 if t102==1300 & stack==4 & q87==1300215
replace pid=1 if t102==1300 & stack==5 & q87==1300703
replace pid=1 if t102==1300 & stack==6 & q87==1300116

replace pid=1 if t102==1250 & stack==1 & q87==1250226
replace pid=1 if t102==1250 & stack==2 & q87==1250220
replace pid=1 if t102==1250 & stack==3 & q87==1250320
replace pid=1 if t102==1250 & stack==4 & q87==1250110
replace pid=1 if t102==1250 & stack==5 & q87==1250336
replace pid=1 if t102==1250 & stack==6 & q87==1250626
replace pid=1 if t102==1250 & stack==7 & q87==1250720
replace pid=1 if t102==1250 & stack==8 & q87==1250337

replace pid=1 if t102==1276 & stack==1 & q87==1276521
replace pid=1 if t102==1276 & stack==2 & q87==1276320
replace pid=1 if t102==1276 & stack==3 & q87==1276113
replace pid=1 if t102==1276 & stack==4 & q87==1276321
replace pid=1 if t102==1276 & stack==5 & q87==1276420

replace pid=1 if t102==1826 & stack==1 & q87==1826320
replace pid=1 if t102==1826 & stack==2 & q87==1826620
replace pid=1 if t102==1826 & stack==3 & q87==1826421
replace pid=1 if t102==1826 & stack==4 & q87==1826902
replace pid=1 if t102==1826 & stack==5 & q87==1826901
replace pid=1 if t102==1826 & stack==6 & q87==1826951
replace pid=1 if t102==1826 & stack==7 & q87==1826720
replace pid=1 if t102==1826 & stack==8 & q87==1826110

replace pid=1 if t102==1620 & stack==1 & q87==1620211
replace pid=1 if t102==1620 & stack==2 & q87==1620314
replace pid=1 if t102==1620 & stack==3 & q87==1620229
replace pid=1 if t102==1620 & stack==4 & q87==1620311
replace pid=1 if t102==1620 & stack==5 & q87==1620313

replace pid=1 if t102==1752 & stack==1 & q87==1752220
replace pid=1 if t102==1752 & stack==2 & q87==1752320
replace pid=1 if t102==1752 & stack==3 & q87==1752810
replace pid=1 if t102==1752 & stack==4 & q87==1752420
replace pid=1 if t102==1752 & stack==5 & q87==1752620
replace pid=1 if t102==1752 & stack==6 & q87==1752520
replace pid=1 if t102==1752 & stack==7 & q87==1752110
replace pid=1 if t102==1752 & stack==8 & q87==1752700
replace pid=1 if t102==1752 & stack==9 & q87==1752000

replace pid=1 if t102==1372 & stack==1 & q87==1372620
replace pid=1 if t102==1372 & stack==2 & q87==1372520
replace pid=1 if t102==1372 & stack==3 & q87==1372110
replace pid=1 if t102==1372 & stack==4 & q87==1372320
replace pid=1 if t102==1372 & stack==5 & q87==1372951
replace pid=1 if t102==1372 & stack==6 & q87==1372001

replace pid=1 if t102==1380 & stack==1 & q87==1380630
replace pid=1 if t102==1380 & stack==2 & q87==1380720
replace pid=1 if t102==1380 & stack==3 & q87==1380331
replace pid=1 if t102==1380 & stack==4 & q87==1380902
replace pid=1 if t102==1380 & stack==5 & q87==1380523
replace pid=1 if t102==1380 & stack==6 & q87==1380212
replace pid=1 if t102==1380 & stack==7 & q87==1380007
replace pid=1 if t102==1380 & stack==8 & q87==1380631

replace pid=1 if t102==1208 & stack==1 & q87==1208320
replace pid=1 if t102==1208 & stack==2 & q87==1208410
replace pid=1 if t102==1208 & stack==3 & q87==1208620
replace pid=1 if t102==1208 & stack==4 & q87==1208230
replace pid=1 if t102==1208 & stack==5 & q87==1208720
replace pid=1 if t102==1208 & stack==6 & q87==1208420
replace pid=1 if t102==1208 & stack==7 & q87==1208421
replace pid=1 if t102==1208 & stack==8 & q87==1208955
replace pid=1 if t102==1208 & stack==9 & q87==1208954

replace pid=1 if t102==1040 & stack==1 & q87==1040320
replace pid=1 if t102==1040 & stack==2 & q87==1040520
replace pid=1 if t102==1040 & stack==3 & q87==1040420
replace pid=1 if t102==1040 & stack==4 & q87==1040600
replace pid=1 if t102==1040 & stack==5 & q87==1040110
replace pid=1 if t102==1040 & stack==6 & q87==1040951
replace pid=1 if t102==1040 & stack==7 & q87==1040422
replace pid=1 if t102==1040 & stack==8 & q87==1040220

replace pid=1 if t102==1442 & stack==1 & q87==1442113
replace pid=1 if t102==1442 & stack==2 & q87==1442320
replace pid=1 if t102==1442 & stack==3 & q87==1442420
replace pid=1 if t102==1442 & stack==4 & q87==1442520
replace pid=1 if t102==1442 & stack==5 & q87==1442951
replace pid=1 if t102==1442 & stack==6 & q87==1442222
replace pid=1 if t102==1442 & stack==7 & q87==1442220
replace pid=1 if t102==1442 & stack==8 & q87==1442009

replace pid=1 if t102==1246 & stack==1 & q87==1246320
replace pid=1 if t102==1246 & stack==2 & q87==1246810
replace pid=1 if t102==1246 & stack==3 & q87==1246620
replace pid=1 if t102==1246 & stack==4 & q87==1246223
replace pid=1 if t102==1246 & stack==5 & q87==1246110
replace pid=1 if t102==1246 & stack==6 & q87==1246901
replace pid=1 if t102==1246 & stack==7 & q87==1246520
replace pid=1 if t102==1246 & stack==8 & q87==1246820

replace pid=1 if t102==1528 & stack==1 & q87==1528320
replace pid=1 if t102==1528 & stack==2 & q87==1528521
replace pid=1 if t102==1528 & stack==3 & q87==1528420
replace pid=1 if t102==1528 & stack==4 & q87==1528330
replace pid=1 if t102==1528 & stack==5 & q87==1528110
replace pid=1 if t102==1528 & stack==6 & q87==1528006
replace pid=1 if t102==1528 & stack==7 & q87==1528526
replace pid=1 if t102==1528 & stack==8 & q87==1528527
replace pid=1 if t102==1528 & stack==9 & q87==1528220
replace pid=1 if t102==1528 & stack==10 & q87==1528600
replace pid=1 if t102==1528 & stack==11 & q87==1528726

replace pid=1 if t102==1056 & stack==1 & q87==1056521
replace pid=1 if t102==1056 & stack==2 & q87==1056421
replace pid=1 if t102==1056 & stack==3 & q87==1056327
replace pid=1 if t102==1056 & stack==4 & q87==1056711
replace pid=1 if t102==1056 & stack==5 & q87==1056112
replace pid=1 if t102==1056 & stack==6 & q87==1056913
replace pid=1 if t102==1056 & stack==7 & q87==1056600
replace pid=1 if t102==1056 & stack==8 & q87==1056328
replace pid=1 if t102==1056 & stack==9 & q87==1056222
replace pid=1 if t102==1056 & stack==10 & q87==1056522
replace pid=1 if t102==1056 & stack==11 & q87==1056427
replace pid=1 if t102==1056 & stack==12 & q87==1056322
replace pid=1 if t102==1056 & stack==13 & q87==1056710
replace pid=1 if t102==1056 & stack==14 & q87==1056111

replace pid=1 if t102==1724 & stack==1 & q87==1724610
replace pid=1 if t102==1724 & stack==2 & q87==1724320
replace pid=1 if t102==1724 & stack==3 & q87==1724220
replace pid=1 if t102==1724 & stack==5 & q87==1724010
replace pid=1 if t102==1724 & stack==6 & q87==1724007
replace pid=1 if t102==1724 & stack==7 & q87==1724905
replace pid=1 if t102==1724 & stack==8 & q87==1724902
replace pid=1 if t102==1724 & stack==9 & q87==1724908
replace pid=1 if t102==1724 & stack==10 & q87==1724907
replace pid=1 if t102==1724 & stack==11 & q87==1724923
replace pid=1 if t102==1724 & stack==12 & q87==1724903
replace pid=1 if t102==1724 & stack==13 & q87==1724922

gen strength=0 if pid==0
replace strength=1 if pid==1 & q88==3
replace strength=2 if pid==1 & q88==2
replace strength=3 if pid==1 & q88==1

* Chapel Hill variables:

gen lrchcen=lrch-5

gen diflrch=lrchcen*lrprtycen
gen negativech=0 if diflrch>=0 & diflrch!=.
replace negativech=1 if diflrch<0
gen negative2ch=0 if diflrch>0 & diflrch!=.
replace negative2ch=1 if diflrch<=0

gen lrproxch=abs(lr-lrch)
gen difproxlrch=lrproxabs-lrproxch

gen lrdirch=lrchcen*lrcen

gen lrsamesidech=0 if lrdirch < . 
replace lrsamesidech=1 if lrdirch>0

gen lroppsidech=0 if lrdirch < . 
replace lroppsidech=1 if lrdirch<0

gen proxsamech=lrproxch*lrsamesidech
gen proxoppch=lrproxch*lroppsidech

gen samechptv=lrsamesidech*ptv
gen oppchptv=lroppsidech*ptv

* Mean party-placement variables: 

bysort t101 stack: egen lrpartycenmean=mean(lrprtycen)
gen diflr=lrpartycenmean*lrprtycen
gen negative=0 if diflr>=0 & diflr!=.
replace negative=1 if diflr<0
gen negative2=0 if diflr>0 & diflr!=.
replace negative2=1 if diflr<=0

gen lrsamesidemean=0
replace lrsamesidemean=1 if (lrcen>0 & lrpartycenmean>0) | (lrcen<0 & lrpartycenmean<0)replace lrsamesidemean=. if lrcen==. | lrpartycenmean==.gen lroppositemean=0
replace lroppositemean=1 if (lrcen<0 & lrpartycenmean>0) | (lrcen>0 & lrpartycenmean<0)replace lroppositemean=. if lrcen==. | lrpartycenmean==.
gen lrsidesmean=0
replace lrsidesmean = 1 if lrsamesidemean == 1
replace lrsidesmean = 2 if lroppositemean == 1
gen oppmeanptv=lroppositemean*ptvgen samemeanptv=lrsamesidemean*ptv
gen proxptv = lrproxabs*ptv

gen lrproxmean=abs(lrcen-lrpartycenmean)
gen diflrmean=lrproxabs-lrproxmean

***

egen id2 = group(id)
sort id2
bysort id2: egen maxptv = max(ptv)

gen firstpreference = 0 if lrproxabs < . & ptv < .
replace firstpreference = 1 if ptv == maxptv
by id2: egen Nfirstprefs = total(firstpreference)   

gen strongfirstpref = 0 if lrproxabs < . & ptv < .
replace strongfirstpref = 1 if firstpreference == 1 & Nfirstprefs == 1

gen votedfirstprefNP = 0 if votedNP < . & firstpreference < .
replace votedfirstprefNP = 1 if votedNP == firstpreference & firstpreference == 1
by id2: egen votedfirstprefNP_ind = max(votedfirstprefNP)

***
xtset id
gen countrystack =t101*100 + stack

label variable lrsameside "Same Side"
label variable lropposite "Opposite Side"
label variable lrproxabs "Proximity Term"
label variable lrsamesidech "Same Side"
label variable lroppsidech "Opposite Side"
label variable lrproxch "Proximity Term"
label variable lrdir "Directional Term"
label variable lr "Left-Right Self-Placement"

drop if lrproxabs == .
drop t103-v302
drop ptv1-lr15sq
drop eu eucen euparty euproxsq euproxabs euprtycen eupartysq euprtycensq eudir eusameside euoppside

saveold "EES 2009 - stacked.dta", replace

