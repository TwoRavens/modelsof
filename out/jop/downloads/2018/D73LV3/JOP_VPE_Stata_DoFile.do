*******************************************************
**Allyson Benton***
**CIDE, Mexico City****
**allyson.benton@cide.edu**
**31 December 2017**
**Party Leader or Party Reputation Concerns?**
*******************************************************

*******************************************************
*******************************************************
**TABLE OF CONTENTS**
**
**
**I. Beginning Procedures
**II. Summary Statistics
**III. Various Preliminary Tests
**IV. Main Models, Table 3 and Appendix 1
**V. Placebo Tests, Table 3 and Appendix 2
**VI. Dynamic Simulations, Figure 1
**VII. Dynamic Panel Models, Appendix 3
*******************************************************
*******************************************************


*******************************************************
*******************************************************
**I. Beginning Procedures
*******************************************************
*******************************************************

*******************************************************
**Select a Working Directory**
*******************************************************
clear

*Select a working directory within stata (using the "cd" command or select "File" then "Change working directory")
*Place "JOP_VPE_Stata_Data.dta" into the working directory

cd "put your path and directory name here"

cd "/Users/allysonbenton/Library/Mobile Documents/com~apple~CloudDocs/Allyson's Documents/Articles/Academic Year 2017-2018/Paper_VerticalPartisanEffects/ArticleVersions/JOP_June2016/RevisedVersion/FinalVersion/DataAnalysis"

*******************************************************
**Load the Data**
*******************************************************
use "JOP_VPE_Stata_Data.dta", clear


*******************************************************
*******************************************************
**II. Summary Statistics
*******************************************************
*******************************************************

total nsm nm sm m

total muniswdebt if year==2015
total muniswcodebt if year==2015
total muniswddebt if year==2015
total muniswbdebt if year==2015
total muniswfdebt if year==2015

sum codebtpc_ia if muniswcodebt==1


*******************************************************
*******************************************************
**III. Various Preliminary Tests
*******************************************************
*******************************************************

*******************************************************
**Test for Unit Roots**
*******************************************************

*Balancing the data
save "JOP_VPE_Stata_Data_balanced.dta", replace
egen nmiss = rowmiss(stotdebtpc_ia)
keep if nmiss == 0
drop nmiss
egen nobs = count(year), by(muni)
keep if nobs == 11
drop nobs
tab year

save "JOP_VPE_Stata_Data_balanced.dta", replace

*Unit root tests
xtunitroot ht scodebtpc_ia1
xtunitroot ht scodebtpc_ia1, trend
xtunitroot breitung scodebtpc_ia1
xtunitroot breitung scodebtpc_ia1, trend
xtunitroot llc scodebtpc_ia1
xtunitroot llc scodebtpc_ia1, trend

xtunitroot ht sddebtpc_ia1
xtunitroot ht sddebtpc_ia1, trend
xtunitroot breitung sddebtpc_ia1
xtunitroot breitung sddebtpc_ia1, trend
xtunitroot llc sddebtpc_ia1
xtunitroot llc sddebtpc_ia1, trend

xtunitroot ht sbdebtpc_ia1
xtunitroot ht sbdebtpc_ia1, trend
xtunitroot breitung sbdebtpc_ia1
xtunitroot breitung sbdebtpc_ia1, trend
xtunitroot llc sbdebtpc_ia1
xtunitroot llc sbdebtpc_ia1, trend

save "JOP_VPE_Stata_Data_balanced.dta", replace

*******************************************************
**Assess the IVs for "Sluggishness"**
*******************************************************
clear

use "JOP_VPE_Stata_Data.dta", clear

xtset muni year

xtsum ip_sassetspc_ia1
xtsum ip_vertimbal_ia
xtsum margindex
xtsum margvic
xtsum ip_stotpop

xttab nsm
xttab nm
xttab sm
xttab m 

*******************************************************
**Check Residuals for Autocorrelation and Heteroskedasticity**
*******************************************************

**Heteroskedasticity**
xtreg scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l.sddebtpc_ia1 l.sbdebtpc_ia1 l.sfdebtpc_ia1 margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni ip_sassetspc_ia1 ip_vertimbal_ia margindex ip_stotpop i.year, fe
xttest3

**Autocorrelation**
*need to create lagged variables
gen lagsscodebtpc_ia1 = l.scodebtpc_ia1
gen lagssddebtpc_ia1 = l.sddebtpc_ia1
gen lagssbdebtpc_ia1 = l.sbdebtpc_ia1 
gen lagssfdebtpc_ia1 = l.sfdebtpc_ia1 
gen lagsip_sassetspc_ia1 = l.ip_sassetspc_ia1
gen lagsip_vertimbal_ia = l.ip_vertimbal_ia 

xtserial scodebtpc_ia1 lagsscodebtpc_ia1 lagssddebtpc_ia1 lagssbdebtpc_ia1 lagssfdebtpc_ia1 nm sm m margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni ip_sassetspc_ia1 lagsip_sassetspc_ia1 ip_vertimbal_ia lagsip_vertimbal_ia margindex ip_stotpop num_year2 num_year3 num_year4 num_year5 num_year6 num_year7 num_year8 num_year9 num_year10 num_year11 num_state2 num_state3 num_state4 num_state5 num_state6 num_state7 num_state8 num_state9 num_state10 num_state11 num_state12 num_state13 num_state14 num_state15 num_state16 num_state17 num_state18 num_state19 num_state21 num_state22 num_state23 num_state24 num_state25 num_state26 num_state27 num_state28 num_state29 num_state30 num_state31

*******************************************************
**Check Need for Year Fixed Effects**
*******************************************************

xtreg scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l.sddebtpc_ia1 l.sbdebtpc_ia1 l.sfdebtpc_ia1 margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni ip_sassetspc_ia1 ip_vertimbal_ia margindex ip_stotpop i.year, fe
testparm i.year


*******************************************************
*******************************************************
**IV. Main Models, Table 3 and Appendix 1
*******************************************************
*******************************************************

*******************************************************
**Models for Commercial Bank & Non-Bank Financial Entity Debt**
*******************************************************

xtset muni year
set matsize 11000

xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state, het corr(ar1)
xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswdebt==1, het corr(ar1)
xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1, het corr(ar1)
xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1 & muniswddebt==1, het corr(ar1)

*******************************************************
**Table 3, Models 1-4**
*******************************************************
*install eststo
findit eststo //note: follow instructions to install

eststo clear
quietly xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state, het corr(ar1)
eststo
quietly xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswdebt==1, het corr(ar1)
eststo
quietly xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1, het corr(ar1)
eststo
quietly xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1 & muniswddebt==1, het corr(ar1)
eststo
esttab using "Table31.csv", nogaps se star(* 0.10 ** 0.05 *** 0.01) mtitles("All Municipalities" "Municipalities with Any Debt" "Municipalities with Commercial Bank & Non-Bank Financial Entity Debt" "Municipalities with Commercial Bank & Non-Bank Financial Entity and Development Bank Debt") scalars(N N_g g_min g_avg g_max chi2 p rho r2) compress

*******************************************************
**Long-Term Effects, Online Appendix 1
*******************************************************
quietly xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state, het corr(ar1)
nlcom _b[nm]/(1-_b[l.scodebtpc_ia1])
nlcom _b[sm]/(1-_b[l.scodebtpc_ia1])
nlcom _b[m]/(1-_b[l.scodebtpc_ia1])

quietly xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswdebt==1, het corr(ar1)
nlcom _b[nm]/(1-_b[l.scodebtpc_ia1])
nlcom _b[sm]/(1-_b[l.scodebtpc_ia1])
nlcom _b[m]/(1-_b[l.scodebtpc_ia1])

quietly xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1, het corr(ar1)
nlcom _b[nm]/(1-_b[l.scodebtpc_ia1])
nlcom _b[sm]/(1-_b[l.scodebtpc_ia1])
nlcom _b[m]/(1-_b[l.scodebtpc_ia1])

quietly xtpcse scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1 & muniswddebt==1, het corr(ar1)
nlcom _b[nm]/(1-_b[l.scodebtpc_ia1])
nlcom _b[sm]/(1-_b[l.scodebtpc_ia1])
nlcom _b[m]/(1-_b[l.scodebtpc_ia1])


*******************************************************
*******************************************************
**V. Placebo Tests, Table 3 and Appendix 2
*******************************************************
*******************************************************

************************************************************
**Models for Development Bank Debt and Bond Debt**
************************************************************

xtset muni year
set matsize 11000
**Development Bank Debt**
xtpcse sddebtpc_ia1 nm sm m l.sddebtpc_ia1 l(0/1).(scodebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state, het corr(ar1)
xtpcse sddebtpc_ia1 nm sm m l.sddebtpc_ia1 l(0/1).(scodebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswdebt==1, het corr(ar1)
xtpcse sddebtpc_ia1 nm sm m l.sddebtpc_ia1 l(0/1).(scodebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1, het corr(ar1)
xtpcse sddebtpc_ia1 nm sm m l.sddebtpc_ia1 l(0/1).(scodebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1 & muniswddebt==1, het corr(ar1)

**Bond Debt**
xtpcse sbdebtpc_ia1 nm sm m l.sbdebtpc_ia1 l(0/1).(scodebtpc_ia1 sddebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state, het corr(ar1)
xtpcse sbdebtpc_ia1 nm sm m l.sbdebtpc_ia1 l(0/1).(scodebtpc_ia1 sddebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswdebt==1, het corr(ar1)
xtpcse sbdebtpc_ia1 nm sm m l.sbdebtpc_ia1 l(0/1).(scodebtpc_ia1 sddebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1, het corr(ar1)
xtpcse sbdebtpc_ia1 nm sm m l.sbdebtpc_ia1 l(0/1).(scodebtpc_ia1 sddebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1 & muniswddebt==1, het corr(ar1)

*******************************************************
**Table 3, Models 5-8
*******************************************************
eststo clear
quietly xtpcse sddebtpc_ia1 nm sm m l.sddebtpc_ia1 l(0/1).(scodebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state, het corr(ar1)
eststo
quietly xtpcse sddebtpc_ia1 nm sm m l.sddebtpc_ia1 l(0/1).(scodebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswdebt==1, het corr(ar1)
eststo
quietly xtpcse sbdebtpc_ia1 nm sm m l.sbdebtpc_ia1 l(0/1).(scodebtpc_ia1 sddebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state, het corr(ar1)
eststo
quietly xtpcse sbdebtpc_ia1 nm sm m l.sbdebtpc_ia1 l(0/1).(scodebtpc_ia1 sddebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswdebt==1, het corr(ar1)
eststo
esttab using "Table32.csv", nogaps se star(* 0.10 ** 0.05 *** 0.01) mtitles("All Municipalities" "Municipalities with Any Debt" "All Municipalities" "Municipalities with Any Debt") scalars(N N_g g_min g_avg g_max chi2 p rho r2) compress

*******************************************************
**Remaining Models, Online Appendix 2
*******************************************************
eststo clear
quietly xtpcse sddebtpc_ia1 nm sm m l.sddebtpc_ia1 l(0/1).(scodebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1, het corr(ar1)
eststo
quietly xtpcse sddebtpc_ia1 nm sm m l.sddebtpc_ia1 l(0/1).(scodebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1 & muniswddebt==1, het corr(ar1)
eststo
quietly xtpcse sbdebtpc_ia1 nm sm m l.sbdebtpc_ia1 l(0/1).(scodebtpc_ia1 sddebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1, het corr(ar1)
eststo
quietly xtpcse sbdebtpc_ia1 nm sm m l.sbdebtpc_ia1 l(0/1).(scodebtpc_ia1 sddebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year i.state if muniswcodebt==1 & muniswddebt==1, het corr(ar1)
eststo
esttab using "Appendix2.csv", nogaps se star(* 0.10 ** 0.05 *** 0.01) mtitles("Municipalities with Commercial Bank & Non-Bank Financial Entity Debt" "Municipalities with Commercial Bank & Non-Bank Financial Entity & Development Bank Debt" "Municipalities with Commercial Bank & Non-Bank Financial Entity Debt" "Municipalities with Commercial Bank & Non-Bank Financial Entity & Development Bank Debt") scalars(N N_g g_min g_avg g_max chi2 p rho r2) compress


*******************************************************
*******************************************************
**VI. Dynamic Simulations, Figure 1
*******************************************************
******************************************************* 

*install dynsim
findit dynsim //note: follow instructions to install

*install estsimp
findit estsimp //note: follow instructions to install

*place all ado files included in the JOP data archive directly into the working directory (dynsim, estsimp)

*******************************************************
**Using dynsim**
*******************************************************
**load dynsim**
do "dynsim.ado" //note: place this file in the working directory

**Figure 1a: All Munis**
xtset muni year
tsset muni year
set matsize 11000

sum scodebtpc_ia1 if year==2005
dynsim, dv(scodebtpc_ia1) ldv(lagsscodebtpc_ia1) ldv_val(.3522375) time(year) pv(muni) pv_start(2005) /*
*/ scen1(nm 1 sm 0 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /* 
*/ scen2(nm 0 sm 1 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ scen3(nm 0 sm 0 m 1 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ scen4(nm 0 sm 0 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ command(regress) estoptions(robust cluster(muni)) n(10) /*
*/ scheme(sj) ytitle("Com. Bank & Non-Bank Fin. Ent. Debt") ylabel(0(1)4)/*
*/ xtitle("Year + t") xlabel(1(1)11)/*
*/ title() /*
*/ legend(label(1 "nm") label(2 "sm") label(3 "m") label(4 "nsm"))/*
*/ note("Note: Bars depict 95% confidence intervals") /*
*/ lstyle(p1 p5 p10 p15) msymbol(O S D T) 

**Figure 1b: Munis with Debt**
xtset muni year
set matsize 11000

sum scodebtpc_ia1 if year==2005 & muniswdebt==1
dynsim if muniswdebt==1, dv(scodebtpc_ia1) ldv(lagsscodebtpc_ia1) ldv_val(.5007455) time(year) pv(muni) pv_start(2005) /*
*/ scen1(nm 1 sm 0 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 gubelectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /* 
*/ scen2(nm 0 sm 1 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 gubelectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ scen3(nm 0 sm 0 m 1 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 gubelectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ scen4(nm 0 sm 0 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 gubelectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ command(regress) estoptions(robust cluster(muni)) n(10) /*
*/ scheme(sj) ytitle("Com. Bank & Non-Bank Fin. Ent. Debt") ylabel(0(1)4)/*
*/ xtitle("Year + t") xlabel(1(1)11)/*
*/ title() /*
*/ legend(label(1 "NM") label(2 "SM") label(3 "M") label(4 "NSM"))/*
*/ note("Note: Bars depict 95% confidence intervals") /*
*/ lstyle(p15) msymbol(O S D T)

*******************************************************
**Using dynsim_pcse; same results as above
*******************************************************
**load dynsim**
do "dynsim_pcse.ado" //note: place this file in the working directory

**Figure 1a: All Munis**
xtset muni year
tsset muni year
set matsize 11000

sum scodebtpc_ia1 if year==2005
dynsim_pcse, dv(scodebtpc_ia1) ldv(lagsscodebtpc_ia1) ldv_val(.3522375) time(year) pv(muni) pv_start(2005) /*
*/ scen1(nm 1 sm 0 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /* 
*/ scen2(nm 0 sm 1 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ scen3(nm 0 sm 0 m 1 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ scen4(nm 0 sm 0 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ command(regress) estoptions(robust cluster(muni)) n(10) /*
*/ scheme(sj) ytitle("Com. Bank & Non-Bank Fin. Ent. Debt") ylabel(0(1)4)/*
*/ xtitle("Year + t") xlabel(1(1)11)/*
*/ title() /*
*/ legend(label(1 "nm") label(2 "sm") label(3 "m") label(4 "nsm"))/*
*/ note("Note: Bars depict 95% confidence intervals") /*
*/ lstyle(p1 p5 p10 p15) msymbol(O S D T) 

**Figure 1b: Munis with Debt**
xtset muni year
set matsize 11000

sum scodebtpc_ia1 if year==2005 & muniswdebt==1
dynsim_pcse if muniswdebt==1, dv(scodebtpc_ia1) ldv(lagsscodebtpc_ia1) ldv_val(.5007455) time(year) pv(muni) pv_start(2005) /*
*/ scen1(nm 1 sm 0 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 gubelectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /* 
*/ scen2(nm 0 sm 1 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 gubelectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ scen3(nm 0 sm 0 m 1 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 gubelectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ scen4(nm 0 sm 0 m 0 lagssddebtpc_ia1 mean lagssbdebtpc_ia1 mean lagssfdebtpc_ia1 mean sddebtpc_ia1 mean sbdebtpc_ia1 mean sfdebtpc_ia1 mean melectyear 0 gubelectyear 0 margvic mean ip_sassetspc_ia1 mean lagsip_sassetspc_ia1 mean ip_vertimbal_ia mean lagsip_vertimbal_ia mean margindex mean ip_stotpop mean /*
*/ num_state1-num_state31 mean) /*
*/ command(regress) estoptions(robust cluster(muni)) n(10) /*
*/ scheme(sj) ytitle("Com. Bank & Non-Bank Fin. Ent. Debt") ylabel(0(1)4)/*
*/ xtitle("Year + t") xlabel(1(1)11)/*
*/ title() /*
*/ legend(label(1 "NM") label(2 "SM") label(3 "M") label(4 "NSM"))/*
*/ note("Note: Bars depict 95% confidence intervals") /*
*/ lstyle(p15) msymbol(O S D T)


*******************************************************
*******************************************************
**VII. Dynamic Panel Models, Appendix 3**
*******************************************************
******************************************************* 

xtset muni year
set matsize 11000

*Difference GMM*two-step
xtabond2 scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year if muniswdebt==1, gmm(l.scodebtpc_ia1, lag(2 .)) gmm(l.(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1 ip_sassetspc_ia1 ip_vertimbal_ia margindex), lag(1 .)) iv(nm sm m PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni margvic melectyear gubelectyear ip_stotpop i.year) ar(2) nolevel small robust twostep
xtabond2 scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year if muniswcodebt==1, gmm(l.scodebtpc_ia1, lag(2 .)) gmm(l.(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1 ip_sassetspc_ia1 ip_vertimbal_ia margindex), lag(1 .)) iv(nm sm m PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni margvic melectyear gubelectyear ip_stotpop i.year) ar(2) nolevel small robust twostep
xtabond2 scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year if muniswcodebt==1 & muniswddebt==1, gmm(l.scodebtpc_ia1) gmm(l.(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1 ip_sassetspc_ia1 ip_vertimbal_ia margindex)) iv(nm sm m PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni margvic melectyear gubelectyear ip_stotpop i.year) ar(2) nolevel small robust twostep

**Appendix 3**
eststo clear
xtabond2 scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year if muniswdebt==1, gmm(l.scodebtpc_ia1, lag(2 .)) gmm(l.(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1 ip_sassetspc_ia1 ip_vertimbal_ia margindex), lag(1 .)) iv(nm sm m PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni margvic melectyear gubelectyear ip_stotpop i.year) ar(2) nolevel small robust twostep
eststo
xtabond2 scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year if muniswcodebt==1, gmm(l.scodebtpc_ia1, lag(2 .)) gmm(l.(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1 ip_sassetspc_ia1 ip_vertimbal_ia margindex), lag(1 .)) iv(nm sm m PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni margvic melectyear gubelectyear ip_stotpop i.year) ar(2) nolevel small robust twostep
eststo
xtabond2 scodebtpc_ia1 nm sm m l.scodebtpc_ia1 l(0/1).(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1) margvic melectyear gubelectyear PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni l(0/1).ip_sassetspc_ia1 l(0/1).ip_vertimbal_ia margindex ip_stotpop i.year if muniswcodebt==1 & muniswddebt==1, gmm(l.scodebtpc_ia1) gmm(l.(sddebtpc_ia1 sbdebtpc_ia1 sfdebtpc_ia1 ip_sassetspc_ia1 ip_vertimbal_ia margindex)) iv(nm sm m PAN_Muni PRD_Muni PANPRD_Muni OTHER_Muni margvic melectyear gubelectyear ip_stotpop i.year) ar(2) nolevel small robust twostep
eststo
esttab using "Appendix3.csv", nogaps se star(* 0.10 ** 0.05 *** 0.01)  /*
*/ mtitles("All Municipalities" "Municipalities with Debt" "Municipalities with Commercial Bank & Non-Bank Financial Entity Debt" "Municipalities with Commercial Bank & Non-Bank Financial Entity & Development Bank Debt") /*
*/ scalars(N N_g g_min g_avg g_max artests ar1 ar1p ar2 ar2p sargan sar_df sarganp hansen hansen_df hansenp artype vcetype twostep small esttype sig2 sigma j) compress
