clear
clear matrix
clear mata
set mem 500m
set maxvar 15000
set matsize 800
set more off
use "C:\Users\User\Dropbox\LAPTOP\RAND\Data\cams2\cams_long_cons_time-use", clear
//use "C:\Users\beenj\Dropbox\LAPTOP_db\RAND\Data\cams2\cams_long_cons_time-use", clear

////////////////////////////////////////////////////////////PRODUCE DESCRIPTIVE TABLES 1-3
//Table 1
//consumption
foreach x in wxhpspend wxhpspend2 wxhpspendsup wxtotcons wxvhclmnt wxdishw wxwashdry wxhmrepsvc wxhsekpsvc wxyrdsvc wxdinout {
sum `x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

//time use
foreach x in tuwx_clean tuwx_wash tuwx_yrd tuwx_shop tuwx_cook tuwx_monmng tuwx_diy tuwx_car tuwx_hp {
sum `x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

//financial
foreach x in hahous hamort finw2 hadebt rbeq10k hastck {
sum `x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

//household
gen bhlt=(rshlt==5)
gen bhltp=(sshlt==5)

foreach x in rage sret1 bhlt bhltp hcpl cams4 cams5 cams6 {
sum `x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}


//Table 2
preserve
set more off
keep if ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0  & rage>50 & rage<81
foreach x in tuwx_clean tuwx_wash tuwx_yrd tuwx_shop tuwx_cook tuwx_monmng tuwx_diy tuwx_car tuwx_hp {
tabstat `x', by(camswave) st(mean sd)
gen d`x'=(`x'>0)
tabstat d`x', by(camswave) st(mean sd)
}
restore

//Table 3
preserve
set more off
keep if ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0  & rage>50 & rage<81
foreach x in wxhpspend wxhpspend2 wxhpspendsup wxtotcons wxvhclmnt wxdishw wxwashdry wxhmrepsvc wxhsekpsvc wxyrdsvc wxdinout  {
tabstat `x', by(camswave) st(mean sd)
gen d`x'=(`x'>0)
tabstat d`x', by(camswave) st(mean sd)
}
restore

////////////////////////////////////////////////////////////PRODUCE FIGURES
//Figure 1
preserve
keep if ((rlbrf==3) | (rlbrf==5) | (rlbrf==6) | (rlbrf==7)) & hahous~=0 & hahous~=.  & rage>50 & rage<81
gen perc=hahous-l.hahous
collapse (mean) hahous perc hpi_usa cs (sd) sd=hahous, by(camswave)
sum hahous
sum sd
label var perc "Mean housing wealth change (1,000's of U.S. dollars)"
label var camswave "Year"
graph twoway (bar perc camswave, lcolor(black) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) 
restore

//Figure A.1
preserve
collapse (mean) hahous hpi_usa cs (sd) sd=hahous, by(camswave)
label var hahous "Mean house price (1,000's of U.S. dollars)"
label var hpi_usa "U.S. House Price Index"
label var cs "Case-Shiller Index (20 cities)"
label var camswave "Year"
graph twoway (line hahous camswave, lcolor(black) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) 
restore

//Figure A.2
preserve
collapse (mean) hahous hpi_usa cs (sd) sd=hahous, by(camswave)
label var hahous "Mean house price (1,000's of U.S. dollars)"
label var hpi_usa "U.S. House Price Index"
label var cs "Case-Shiller Index (20 cities)"
label var camswave "Year"
graph twoway (line hpi_usa camswave, lcolor(black) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white)))  (line cs camswave, lcolor(black) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) 
restore

//Figure A.3
preserve
collapse (mean) hpi_1 hpi_2 hpi_3 hpi_4 hpi_5 hpi_6 hpi_7 hpi_8 hpi_9, by(rcendiv camswave)
label var hpi_1 "NE"
label var hpi_2 "MA"
label var hpi_3 "ENC"
label var hpi_4 "WNC"
label var hpi_5 "SA"
label var hpi_6 "ESA"
label var hpi_7 "WSA"
label var hpi_8 "Mount"
label var hpi_9 "Pacif"
label var camswave "Year"
graph twoway (line hpi_1 camswave, lcolor(black) lpattern(solid) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") ytitle("Regional House Price Index") graphregion(color(white))) (line hpi_2 camswave, lcolor(black) lpattern(dot) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white)))  (line hpi_3 camswave, lcolor(black) lpattern(dash) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) (line hpi_4 camswave, lcolor(black) lpattern(longdash) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) ///
(line hpi_5 camswave, lcolor(black) lpattern(dash_dot) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") ytitle("Regional House Price Index") graphregion(color(white))) (line hpi_6 camswave, lcolor(black) lpattern(longdash_dot) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white)))  (line hpi_7 camswave, lcolor(black) lpattern(shortdash)  xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) (line hpi_8 camswave, lcolor(black) lpattern(shortdash_dot) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) ///
(line hpi_9 camswave, lcolor(black) lpattern("..-..") xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") ytitle("Regional House Price Index") graphregion(color(white)))
restore

//Figure A.4
preserve
collapse (mean) ur_1 ur_2 ur_3 ur_4 ur_5 ur_6 ur_7 ur_8 ur_9, by(camswave)
label var ur_1 "NE"
label var ur_2 "MA"
label var ur_3 "ENC"
label var ur_4 "WNC"
label var ur_5 "SA"
label var ur_6 "ESA"
label var ur_7 "WSA"
label var ur_8 "Mount"
label var ur_9 "Pacif"
label var camswave "Year"
graph twoway (line ur_1 camswave, lcolor(black) lpattern(solid) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") ytitle("Regional Unemployment Rate") graphregion(color(white))) (line ur_2 camswave, lcolor(black) lpattern(dot) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white)))  (line ur_3 camswave, lcolor(black) lpattern(dash) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) (line ur_4 camswave, lcolor(black) lpattern(longdash) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) ///
(line ur_5 camswave, lcolor(black) lpattern(dash_dot) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) (line ur_6 camswave, lcolor(black) lpattern(longdash_dot) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white)))  (line ur_7 camswave, lcolor(black) lpattern(shortdash)  xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) (line ur_8 camswave, lcolor(black) lpattern(shortdash_dot) xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white))) ///
(line ur_9 camswave, lcolor(black) lpattern("..-..") xlabel(2 "2003" 3 "2005" 4 "2007" 5 "2009" 6 "2011") graphregion(color(white)))
restore

//ONLINE APPENDIX
//Table A.9
preserve
use "C:\Users\beenj\Dropbox\LAPTOP_db\RAND\Data\cams2\cams_long_cons_time-use", clear
keep if camswave>2
sum hhidpn //All
restore
sum hhidpn
sum hhidpn if trim_dhp==.
sum hhidpn if trim_dhp==. & trim_dwxhpspend==.
sum hhidpn if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf~=. & rlbrf~=.))
sum hhidpn if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7))
sum hhidpn if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. 
sum hhidpn if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0


//Table A.10
//time use
//home production
foreach x in clean wash yrd shop cook monmng diy car hp {
sum tuwx_`x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

foreach x in work dinout entrtn comp tv read1 read2 music sleep walk sports visit comm pray hyg pets affect help volunt reli relim health games sing knit {
sum tuwx_`x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

gen tuwx_sum=tuwx_clean+tuwx_wash+tuwx_yrd+tuwx_shop+tuwx_cook+tuwx_monmng+tuwx_diy+tuwx_car+tuwx_work+tuwx_dinout+tuwx_entrtn+tuwx_comp+tuwx_tv+tuwx_read1+tuwx_read2+tuwx_music+tuwx_sleep+tuwx_walk+tuwx_sports+tuwx_visit+tuwx_comm+tuwx_pray+tuwx_hyg+tuwx_pets+tuwx_affect+tuwx_help+tuwx_volunt+tuwx_reli+tuwx_relim+tuwx_health+tuwx_games+tuwx_sing+tuwx_knit
sum tuwx_sum if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det



//Table A.11
//consumption
//subst
set more off
foreach x in wxdinout wxhsekpsvc wxyrdsvc wxhmrepsvc wxvhclmnt wxdishw wxwashdry wxhmrepsup wxhsekpsup wxyrdsup wxhpspend {
//sum `x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
gen p`x'=`x'/wxtotcons
sum p`x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

//quasi
set more off
foreach x in wxcloth {
sum `x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

//nonsubst
set more off
foreach x in wxcashgift wxconts wxdrugs wxelectric wxfdbev wxgas wxheat wxhlthins wxhlthsvc wxhmrntins wxmedsup wxmort_int wxptax wxrent wxtelecom wxtickts wxtripvac wxvhclins wxwater wxfridge wxpc wxtv wxhob_min wxsprteq wxxarpay wxprscare wxcaruse wxfurnish wxauto_all_new {
sum `x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

//Subst aggregates
set more off
foreach x in wxhpspend wxhpspendsup wxhpspendsupcloth {
sum `x' if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det
}

sum wxtotcons if trim_dhp==. & trim_dwxhpspend==. & ((l.rlbrf==3 & rlbrf==3) | (l.rlbrf==5 & rlbrf==5) | (l.rlbrf==6 & rlbrf==6) | (l.rlbrf==7 & rlbrf==7)) & l.house_own==1 & l.house_own~=. & l.tran_house==0, det










//TABLE A.12





















