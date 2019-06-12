clear
clear matrix
clear mata
set mem 500m
set maxvar 15000
set matsize 800
set more off
use "C:\Users\User\Dropbox\LAPTOP\RAND\Data\cams2\cams_long_cons_time-use", clear
//use "C:\Users\beenj\Dropbox\LAPTOP_db\RAND\Data\cams2\cams_long_cons_time-use", clear


//SELECTION
set more off
keep if rage>50
keep if camswave>2
keep if rage<81


////////////////////////////////////////////////////////////////Create variables
//INVERSE HYPERBOLIC TRANSFORMATIONS
//Generate IHS en d.IHS time-use vars
foreach x in mp hp l other work clean wash yrd shop cook monmng entrtn diy car dinout subst tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit {
//FD
gen dtuwx_`x'=d.tuwx_`x'
gen dtuwx_`x'_hh=d.tuwx_`x'_hh
//Inverse Hyperbolic Sine
gen ihstuwx_`x' = ln(tuwx_`x'+(tuwx_`x'^2+1)^(0.5))
gen ihstuwx_`x'_hh = ln(tuwx_`x'_hh+(tuwx_`x'_hh^2+1)^(0.5))
//FD IHS
gen dihstuwx_`x'=d.ihstuwx_`x'
gen dihstuwx_`x'_hh=d.ihstuwx_`x'_hh
}

//Generate IHS en d.IHS consumption vars
gen wxhpspend=wxvhclmnt+wxdishw+wxwashdry+wxhmrepsvc+wxhsekpsvc+wxyrdsvc+wxdinout
gen wxhpspend2=wxvhclmnt+wxhmrepsvc+wxhsekpsvc+wxyrdsvc+wxdinout
gen wxhpspendsup=wxvhclmnt+wxdishw+wxwashdry+wxhmrepsup+wxhmrepsvc+wxhsekpsup+wxhsekpsvc+wxyrdsup+wxyrdsvc+wxdinout
gen wxhpspendsupcloth=wxvhclmnt+wxdishw+wxwashdry+wxhmrepsup+wxhmrepsvc+wxhsekpsup+wxhsekpsvc+wxyrdsup+wxyrdsvc+wxdinout+wxcloth
gen wxhphome=wxvhclmnt+wxdishw+wxwashdry+wxhmrepsvc+wxhsekpsvc+wxyrdsvc

gen wxnonsub=wxtotcons-wxhpspend
gen wxhpspendhome=wxvhclmnt+wxdishw+wxwashdry+wxhsekpsvc+wxyrdsvc+wxdinout
gen wxhpspendgard=wxvhclmnt+wxdishw+wxwashdry+wxhsekpsvc+wxdinout
gen wxhpspendfood=wxvhclmnt+wxdishw+wxwashdry+wxhmrepsvc+wxhsekpsvc+wxyrdsvc
gen wxhpspendcs=wxvhclmnt+wxdishw+wxwashdry+wxhmrepsvc+wxyrdsvc+wxdinout

gen wxhpnonfood=wxhpspend-wxdinout

foreach x in wxhpspend wxhpspend2 wxhpspendsup wxtotcons wxnonsub wxvhclmnt wxdishw wxwashdry wxhmrepsvc wxhsekpsvc wxyrdsvc wxdinout wxhphome wxhpspendhome wxhpspendgard wxhpspendfood wxhpspendcs wxhpnonfood wxhpspendsupcloth {
//FD
gen d`x'=d.`x'
//Inverse Hyperbolic Sine
gen ihs`x' = ln(`x'+(`x'^2+1)^(0.5))
//FD IHS
gen dihs`x'=d.ihs`x'
//FD Lag IHS
gen lihs`x'=l.ihs`x'
gen dlihs`x'=d.lihs`x'
}


//Equi scales
foreach x in wxhpspend {
//Oxford scale
gen `x'oxford=`x' if hhhres==1
replace `x'oxford=`x'/(1+(0.7*(hhhres-1))) if hhhres>1
//OECD
gen `x'oecd=`x' if hhhres==1
replace `x'oecd=`x'/(1+(0.5*(hhhres-1))) if hhhres>1
//Square root
gen `x'root=`x'/(hhhres^0.5)
//FD
gen d`x'oxford=d.`x'oxford
gen d`x'oecd=d.`x'oecd
gen d`x'root=d.`x'root
//Inverse Hyperbolic Sine
gen ihs`x'oxford = ln(`x'oxford+(`x'oxford^2+1)^(0.5))
gen ihs`x'oecd = ln(`x'oecd+(`x'oecd^2+1)^(0.5))
gen ihs`x'root = ln(`x'root+(`x'root^2+1)^(0.5))
//FD IHS
gen dihs`x'oxford=d.ihs`x'oxford
gen dihs`x'oecd=d.ihs`x'oecd
gen dihs`x'root=d.ihs`x'root
}


//TRIMMING
//Trim time-use vars
set more off
local l_lim = 1
local u_lim = 100 - `l_lim'
local eps = 0.0001

foreach x in hp mp cook {
gen trim_d`x'=.

forval i = 2/6 {
centile dtuwx_`x' if camswave==`i', centile (`l_lim' `u_lim')
replace trim_d`x' = 1 if dtuwx_`x'<r(c_1)-`eps' & dtuwx_`x'~=. & camswave==`i' 
replace trim_d`x' = 2 if dtuwx_`x'>r(c_2)+`eps' & dtuwx_`x'~=. & camswave==`i'
}

gen trim_d`x'_hh=.

forval i = 2/6 {
centile dtuwx_`x'_hh if camswave==`i', centile (`l_lim' `u_lim')
replace trim_d`x'_hh = 1 if dtuwx_`x'_hh<r(c_1)-`eps' & dtuwx_`x'_hh~=. & camswave==`i' 
replace trim_d`x'_hh = 2 if dtuwx_`x'_hh>r(c_2)+`eps' & dtuwx_`x'_hh~=. & camswave==`i'
}
}

//Trim consumption vars
foreach x in wxhpspend wxhpspend2 wxhpspendsup wxhpspendoxford wxhpspendoecd wxhpspendroot wxtotcons wxnonsub wxvhclmnt wxdishw wxwashdry wxhmrepsvc wxhsekpsvc wxyrdsvc wxdinout wxhphome wxhpspendhome wxhpspendgard wxhpspendfood wxhpspendcs wxhpnonfood wxhpspendsupcloth {
gen trim_d`x'=.
forval i = 2/6 {
centile d`x' if camswave==`i', centile (`l_lim' `u_lim')
replace trim_d`x' = 1 if d`x'<r(c_1)-`eps' & d`x'~=. & camswave==`i' 
replace trim_d`x' = 2 if d`x'>r(c_2)+`eps' & d`x'~=. & camswave==`i'
}
}

//Trim houseprice drop
//tran_house is whether house is bought/sold
gen housedrop=(hahous-l.hahous)/l.hahous if camswave==5 & l.house_own==1 & l.house_own~=. & l.tran_house==0

centile housedrop, centile(33 66)
gen dropth = 3 if housedrop<=r(c_1) & !missing(housedrop)  & l.tran_house==0
replace dropth = 2 if housedrop>r(c_1) & housedrop<=r(c_2) & !missing(housedrop)  & l.tran_house==0
replace dropth = 1 if housedrop>r(c_2) & !missing(housedrop) & l.tran_house==0
egen drop=mean(dropth), by(hhidpn)


//Construct independent variables
//Wave dummies
forvalues i=3(1)6 {
gen cams`i'=(camswave==`i')
gen dcams`i'=d.cams`i'
}

//Instrumental variable
gen ihshahouse=ln(hahous+(hahous^2+1)^(0.5))
gen dihshouse5=d.ihshahous*cams5

gen nethahous=hahous-hamort
gen ihsnethahouse=ln(nethahous+(nethahous^2+1)^(0.5))
gen dihsnethouse5=d.ihsnethahous*cams5

gen ihshatotn=ln(hatotn+(hatotn^2+1)^(0.5))
gen dihstotn5=d.ihshatotn*cams5

gen ihshastck=ln(hastck+(hastck^2+1)^(0.5))
gen dihshastck5=d.ihshastck*cams5

//Age
gen rage2=rage*rage
gen drage=d.rage
gen drage2=d.rage2

gen sage2=sage*sage
gen dsage=d.sage
replace dsage=0 if sage==.
gen dsage2=d.sage2
replace dsage2=0 if sage==.

gen ra62=(rage>=62)
gen ra65=(rage>=65)
gen ra70=(rage>=70)


//Health 
gen dethlt=(rshlt>l.rshlt)
gen imphlt=(rshlt<l.rshlt)
gen dethltp=(sshlt>l.sshlt)
replace dethltp=0 if sshlt==.
gen imphltp=(sshlt<l.sshlt)
replace imphltp=0 if sshlt==.

//Household
gen partsing=(d.hcpl<0)
gen singpart=(d.hcpl>0)

gen hsizeinc=(hhhres>l.hhhres)
gen hsizedec=(hhhres<l.hhhres)

gen sret1=0
replace sret1=1 if ((l.slbrf==3 & slbrf==3) | (l.slbrf==5 & slbrf==5) | (l.slbrf==6 & slbrf==6) | (l.slbrf==7 & slbrf==7))



//REGRESSIONS
//TABLE 4 (A.1)
set more off
foreach x in wxhpspend {
//No controls
ivreg28 dihstuwx_hp (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

//Period controls
ivreg28 dihstuwx_hp dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

//All controls
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

//Weak instruments: Fuller-k
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons fuller(1) r bw(3) small first
lincom _b[dihswxhpspend] + 1

//Aged 65-81
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0 & rage>=65, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

//Non-poor health
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if rshlt<=4 & trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

//Couple
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if hcpl==1 & trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

//Women
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if rgen==2 & trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1
}


//TABLE 5
set more off
foreach x in wxhpspend wxhpspend2 wxhpspendsup wxdinout wxhpspendhome wxhpspendgard wxhpspendfood wxhpspendcs wxhpnonfood wxhpspendsupcloth {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihs`x']=-1
}

//Robustness consumption definition
foreach x in wxdinout {
ivreg28 dihstuwx_cook drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5) if trim_dcook==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1
}


//TABLE 6
//Control local labor market
//Unemployment Rate (UR)
set more off
gen dur_bydiv=d.ur_bydiv
foreach x in wxhpspend {
ivreg28 dihstuwx_hp dur_bydiv drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1
}

gen urdiff=ur_bydiv-ur_usa
gen durdiff=d.urdiff
foreach x in wxhpspend {
ivreg28 dihstuwx_hp durdiff drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1
}

foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if dur_bydiv<=3.1 & trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1
}

//House Price Index (HPI)
set more off
gen dhpi_bydiv=d.hpi_bydiv
foreach x in wxhpspend {
ivreg28 dihstuwx_hp dhpi_bydiv drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1
}

gen hpidiff=hpi_bydiv-hpi_usa
gen dhpidiff=d.hpidiff
foreach x in wxhpspend {
ivreg28 dihstuwx_hp dhpidiff drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1
}

foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if dhpi_bydiv<=19.03 & trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1
}

//UR & HPI
foreach x in wxhpspend {
ivreg28 dihstuwx_hp dur_bydiv dhpi_bydiv drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1
}


//TABLE 7
gen netfin=finw2-hadebt

gen test2=dihshouse5*l.nethahous
gen test5=dihshouse5*l.finw2
gen test7=dihshouse5*l.hadebt
gen test9=dihshouse5*l.rbeq10k

gen ctest2=dihswxhpspend*l.nethahous
gen ctest3=dihswxhpspend*l.netfin
gen ctest6=dihswxhpspend*l.rbeq10k

set more off
foreach x in wxhpspend {

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' ctest2 = dihshouse5 test2  ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' ctest2 = dihshouse5 test2 test5 test7 test9 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' ctest3 = dihshouse5 test5 test7  ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' ctest3 = dihshouse5 test2 test5 test7  test9 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' ctest6 = dihshouse5 test9 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' ctest6 = dihshouse5 test2 test5 test7 test9 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

}



//TABLE A.2
//Baseline
foreach x in wxhpspend {
ivreg28 dihstuwx_hp (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1
}

//Retired/out-of-labforce only
foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==5 & rlbrf==5) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1
}

//Retired only
foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==5 & rlbrf==5)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1
}


//TABLE A.3
//Share
gen persub= wxhpspend/wxtotcons
gen female=(rgen==2)
gen badhealth=(rshlt>4)
gen a65=(rage>=65)
gen ret=(rlbrf==5)
reg persub female a65 hcpl badhealth if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, r
reg persub female a65 hcpl badhealth if trim_dhp==. & trim_dwxhpspend==., r //& ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, r
reg persub female a65 hcpl badhealth house_own ret if trim_dhp==. & trim_dwxhpspend==., r //& ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, r


//TABLE A.4
gen ihsfinw2=ln(finw2+(finw2^2+1)^(0.5))
gen dihsfinw25=d.ihsfinw2*cams5

gen ihshastck=ln(hastck+(hastck^2+1)^(0.5))
gen dihshastck5=d.ihshastck*cams5

//Conditional on other wealth shocks
set more off
foreach x in wxhpspend {

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 dihsfinw25) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 dihshastck5) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

}

//Other wealth shock on renters
set more off
foreach x in wxhpspend {

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihsfinw25) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==0 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshastck5) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==0 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

}

//Stock wealth
foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshastck5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.stock_own==1 & l.stock_own~=. & l.tran_stock==0, nocons gmm r bw(3) small first

test _b[dihswxhpspend]=-1

}


//TABLE A.5
gen lihshahouse=l.ihshahouse
gen d2ihshouse5=d2.ihshahous*cams5
gen dihshouse6=d.ihshahous*cams6

set more off
foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 lihshahouse ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 d2ihshouse5 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(2) small first
lincom _b[dihswxhpspend] + 1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 d.hpi_usa ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 d.ur_usa ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 d.sp ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 dihshouse6 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
lincom _b[dihswxhpspend] + 1

}


//TABLE A.6
set more off
foreach x in wxtotcons wxnonsub wxhpspend wxdinout {
ivreg28 dihs`x' drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 dihshouse5 if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons r bw(3) small first
}


//TABLE A.7
sum dihshouse5 if camswave==5 & trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
gen medh50=(dihshouse5>r(p50)) if camswave==5 & trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0
replace medh50=0 if medh50==. //-6.58%

gen medh25=(dihshouse5>r(p25)) if camswave==5 & trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0
replace medh25=0 if medh25==. //-24.81%

gen medh75=(dihshouse5>r(p75)) if camswave==5 & trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0
replace medh75=0 if medh75==. //+4.80%

gen hou50=dihshouse5*medh50
gen hou75=dihshouse5*medh75
gen hou25=dihshouse5*medh25

set more off
foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 hou25 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 hou50 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 hou75 ) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihswxhpspend]=-1

}


//TABLE A.8
tabstat wxhpspend if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, by(reduc) st(n mean)
tabstat tuwx_hp if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, by(reduc) st(n mean)





////////////////////////////////////////////////////EXTRA
//Check: no retirement spouse variable
foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt  dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
}


//Check: equivalence scales
set more off
foreach x in wxhpspendoxford wxhpspendoecd wxhpspendroot {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first
test _b[dihs`x']=-1
}


//Check: Angrisani
gen dihshouse4=d.ihshahous*cams4

foreach x in wxhpspend {
ivreg28 dihstuwx_hp drage drage2 d.ra62 d.ra65 d.ra70 dethlt imphlt sret1 dethltp imphltp singpart partsing dcams4 dcams5 dcams6 (dihs`x' = dihshouse5 dihshouse4) if trim_dhp==. & trim_d`x'==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, nocons gmm r bw(3) small first

test _b[dihswxhpspend]=-1

}


