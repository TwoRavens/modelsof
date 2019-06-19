*==================================================================================================
set mem 700m
set more off
use "Fertility_data.dta", clear

* =====================
* Generating covariants
* =====================
* generate number of kids below18
gen below18=(age1+age2+age3)

* generate mother age group
gen magegrp=1 if mage<=25
replace magegrp=2 if mage>25 & mage<=30
replace magegrp=3 if mage>30 & mage<=35
replace magegrp=4 if mage>35 & mage<=40
replace magegrp=5 if mage>40

* generating month from last birth ^ 2
gen mlastbirth2=mlastbirth^2

* creating trimsocio
bys mdatgroup: egen mnetincome90=pctile(net_hh_incomefp) if below18>=2, p(90) 

gen trimsocio=1 if net_hh_incomefp<povertyincome
replace trimsocio=2 if net_hh_incomefp>=povertyincome & net_hh_incomefp<mnetincome90
replace trimsocio=3 if net_hh_incomefp>=mnetincome90
forval int=1/3 {
	gen trimsocio`int'=1 if trimsocio==`int'
	replace trimsocio`int'=0 if trimsocio`int'==.
}
drop mnetincome90

/*
*creating trisociod
egen netincome90=pctile(net_hh_incomefp) if below18>=2, p(90) 
gen trisocio1= (net_hh_incomefp<povertyincome)
gen trisocio2= (net_hh_incomefp>=povertyincome & net_hh_incomefp<netincome90)
gen trisocio3= (net_hh_incomefp>=netincome90)
drop netincome90
*/

gen trisocio=1 if trisocio1==1
replace trisocio=2 if trisocio2==1
replace trisocio=3 if trisocio3==1

* generating a dummy variable for newimmigrant (defined eithrt if the mother and/or the father is a new immigrant
gen fnewimmigrant=1 if newimmigrant==1 | newimmigrantbz==1
replace fnewimmigrant=0 if fnewimmigrant==.
 
*======================== * 
* dropping observations
*======================== *
drop if npv<0 
drop if npv>50000
drop if mdatgroup>=5
* only keep Secular, Religious, Ultra-Orthodox and Arab Muslims
drop if net_m_income<0
drop if net_bz_income<0
*======================== *

* replace maxedu with 0 value to missing
gen maxeduc=maxedu
replace maxedu=. if maxedu==0
* mdatgroup==3 & maxedu==1 turn into missing 
replace maxedu=. if maxedu==1 & mdatgroup==3

* generate monthly npv 
gen npvm=npv/12.27 

* generating log income
gen lognetincome=log(net_hh_incomefp+1)
gen logfincome=log(net_bz_incomefp+1)

* generating lag income to be used as an instriments for current income
duplicates drop ficzehut yearinc , force
sort ficzehut yearinc 
gen lag_logfincome=logfincome[_n-1] if ficzehut==ficzehut[_n-1]

* generating cluster
gen agedist_temp=age1*100+age2*10+age3
gen agedistyear_temp=yearinc*1000+agedist_temp
egen agedistyear=group(agedistyear_temp)
* 1686 groups
drop *_temp

* generating number of kdis to be equal to age1+age2+age3+age4
gen nofkids=age1+age2+age3+age4
gen mnofkids=min(below18+1,7)

*=============================================
* merge child allowances levels in 2007 values
*=============================================
sort yearinc mnofkids
merge yearinc mnofkids using CAnewborn
tab _merge
drop _merge mnofkids
drop canbtable
keep if below18>=2

* get rid of duplicates
duplicates drop ficzehut yearinc , force

compress
*==================================================================================================
* log using "Final_Results.smcl", replace
*==================================================================================================

global depvar zconcep
global treatvar npvm
global control maxedu mdatgroup2-mdatgroup4 avgnofkids_5 
global controladd age1birth mlastbirth mlastbirth2 nofkids
global incomespec lognetincome
global macro uneployper gnpchange
global year year1999 year2000 year2001 year2002 year2003 year2004 year2005
global Jew mmizrachi fmizrachi fnewimmigrant

* =============================================
* Table 3: Avg Effect of CA on the P(pregnancy)
* for the whole population
* =============================================
	reg $depvar $treatvar $control $controladd work_bz trisocio2-trisocio3 $year, cluster(agedistyear) robust
 	estimates store reg1, title(parametric_trio) 

	reg $depvar $treatvar $control $controladd $incomespec $year, cluster(agedistyear) robust
 	estimates store reg2, title(parametric_inc) 

	xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3, cluster(agedistyear) robust
 	estimates store reg3, title(nonparam) 

xml_tab reg1 reg2 reg3, stats(N) newappend save("Revise and Resubmit") title(parnm_nonparam) stats(N r2_p) sd2 format(Ncc06) sheet (Table3)
est drop reg1 reg2 reg3

* ===========================
* Table 2: Summary Statistics
* ===========================
tabstat nofkids zconcep npvm age1birth mlastbirth work_bz maxedu avgnofkids_5 age1 age2 age3 age4 net_hh_incomefp net_bz_incomefp if e(sample), by(trisocio) stat(mean median sd count) long col(stat)
tabstat nofkids zconcep npvm age1birth mlastbirth work_bz maxedu avgnofkids_5 age1 age2 age3 age4 net_hh_incomefp net_bz_incomefp if e(sample), by(mdatgroup) stat(mean median sd count) nototal long col(stat)

* =========================================================
* Table 4: The Effect of the PV of CA by Income Category 
* and by Religious Group: Non-Parametric Fertility Controls
* =========================================================
* for the whole population
* ========================
	xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3, cluster(agedistyear) robust
 	estimates store reg, title(nonparam) 
* split by trisocio
* =================
foreach int in 1 2 3 {
	disp `int'
	xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if trisocio==`int', cluster(agedistyear) robust
 	estimates store regs`int', title(nonparamtrisocio`int') 
}
* split by mdatgroup levels 
* =========================
foreach int in 1 2 3 {
	disp `int'
	xi: reg $depvar $treatvar $control $Jew $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int', cluster(agedistyear) robust
 	estimates store regm`int', title(ftrendmdatgroup`int') 
}
foreach int in 4 {
	disp `int'
	xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int', cluster(agedistyear) robust
 	estimates store regm`int', title(ftrendmdatgroup`int')
}
xml_tab reg regs1 regs2 regs3 regm1 regm2 regm3 regm4, stats(N) newappend save("Revise and Resubmit") title(all mdat inc) stats(N r2_p) sd2 format(Ncc06) sheet(Table4)
est drop reg regs1 regs2 regs3 regm1 regm2 regm3 regm4

* =========================================================
* Table 5: The Effect by Income Category and Religion: 
* Non-Parametric Fertility Controls
* =========================================================
* By mdatgroup & trimsocio
* ========================
foreach int in 1 2 3 {    
	foreach soc in 1 2 3 {
	disp `int'
	disp `soc'
	xi: reg $depvar $treatvar $control $Jew $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int' & trimsocio==`soc', cluster(agedistyear) robust
 	estimates store reg`int'`soc', title(`int'`soc')
  }
}
foreach int in 4 {
   foreach soc in 1 2 3 {
	disp `int'
	disp `soc'
	xi: reg $depvar $treatvar $control $incomespec  $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int' & trimsocio==`soc', cluster(agedistyear) robust
	estimates store reg`int'`soc', title(`int'`soc')
  }
}
xml_tab reg11  reg12  reg13  reg21  reg22  reg23  reg31  reg32  reg33  reg41  reg42  reg43 , stats(N) newappend save("Revise and Resubmit") title(by mdat trimsoc) stats(N r2_p) sd2 format(Ncc06) sheet(Table5)
est drop reg11 reg12 reg13 reg21 reg22 reg23 reg31 reg32 reg33 reg41 reg42 reg43

* ====================================
* Table 6: The Effect by Mother's age:
* Non-Parametric Fertility Controls
* ====================================
* split by magegroup WITH year dummies
* ====================================
foreach int in 1 2 3 4 5 {
	disp `int'
	xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if magegrp==`int' & below18>=2, cluster(agedistyear) robust
 	estimates store reg`int', title(mage`int')
}
xml_tab reg1  reg2  reg3  reg4  reg5 , stats(N) newappend save("Revise and Resubmit") title(by mage) stats(N r2_p) sd2 format(Ncc06)  sheet (Table6)
est drop reg1 reg2 reg3 reg4 reg5

log close

*===============================================================================================
* log using "Table_Results_IV.smcl", replace
*=====================================================================
* non parametrics specification with IV
*=====================================================================
global incomeIVspec (lognetincome = lag_logfincome)

* ===========================================================
* Table 10: The Effect of the PV of CA by Income Category and 
* by Religious Group: Instrumenting for Income
* ===========================================================
* for the whole population
* ========================
	xi: ivreg $depvar $treatvar $control $incomeIVspec $year i.below18*age1 i.below18*age2 i.below18*age3, cluster(agedistyear) robust
 	estimates store reg, title(nonparam) 
* split by trisocio
* =================
foreach int in 1 2 3 {
	disp `int'
	xi: ivreg $depvar $treatvar $control $incomeIVspec $year i.below18*age1 i.below18*age2 i.below18*age3 if trisocio==`int', cluster(agedistyear) robust
 	estimates store regs`int', title(nonparamtrisocio`int') 
}
* split by mdatgroup levels 
* =========================
foreach int in 1 2 3 {
	disp `int'
	xi: ivreg $depvar $treatvar $control $Jew $incomeIVspec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int', cluster(agedistyear) robust
 	estimates store regm`int', title(ftrendmdatgroup`int') 
}
foreach int in 4 {
	disp `int'
	xi: ivreg $depvar $treatvar $control $incomeIVspec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int', cluster(agedistyear) robust
 	estimates store regm`int', title(ftrendmdatgroup`int')
}
xml_tab reg regs1 regs2 regs3 regm1 regm2 regm3 regm4, stats(N) newappend save("Revise and Resubmit_iv") title(all mdat inc IV) stats(N r2_p) sd2 format(Ncc06) sheet(Table10)
est drop reg regs1 regs2 regs3 regm1 regm2 regm3 regm4

* =====================================================
* Table 11: The Effect by Income Category and Religion:
* Instrumenting for Income
* =====================================================
* By mdatgroup & trimsocio
* ========================
foreach int in 1 2 3 {    
	foreach soc in 1 2 3 {
	disp `int'
	disp `soc'
	xi: ivreg $depvar $treatvar $control $Jew $incomeIVspec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int' & trimsocio==`soc', cluster(agedistyear) robust
 	estimates store reg`int'`soc', title(`int'`soc')
  }
}
foreach int in 4 {
   foreach soc in 1 2 3 {
	disp `int'
	disp `soc'
	xi: ivreg $depvar $treatvar $control $incomeIVspec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int' & trimsocio==`soc', cluster(agedistyear) robust
	estimates store reg`int'`soc', title(`int'`soc')
  }
}
xml_tab reg11  reg12  reg13  reg21  reg22  reg23  reg31  reg32  reg33  reg41  reg42  reg43 , stats(N) newappend save("Revise and Resubmit_iv") title(by mdat trimsoc IV) stats(N r2_p) sd2 format(Ncc06)  sheet (Table11)
est drop reg11 reg12 reg13 reg21 reg22 reg23 reg31 reg32 reg33 reg41 reg42 reg43

* ==============================================================
* Table 12: The Effect by Mother's age: Instrumenting for Income
* ============================================================== 
* split by magegroup
* ==================
foreach int in 1 2 3 4 5 {
	disp `int'
	xi: ivreg $depvar $treatvar $control $incomeIVspec $year i.below18*age1 i.below18*age2 i.below18*age3 if magegrp==`int' & below18>=2, cluster(agedistyear) robust
 	estimates store reg`int', title(mage`int')
}
xml_tab reg1  reg2  reg3  reg4  reg5, stats(N) newappend save("Revise and Resubmit_iv") title(by magegrp IV) stats(N r2_p) sd2 format(Ncc06) sheet(Table12)
est drop reg1 reg2 reg3 reg4 reg5

log close

*===============================================================================================
* log using "Table_results_FE.smcl", replace
*==================================================================================
* Now we want specification with Mother fixed effect & non parametric specification 
*==================================================================================
global motherid ficzehut
 
* de-meaning the dependent and explanatory variables
foreach vname in $depvar $treatvar avgnofkids_5 mlastbirth mlastbirth2 nofkids maxedu $incomespec $macro yearinc {
	bys $motherid: egen `vname'_fe=mean(`vname')
	replace `vname'_fe= `vname'-`vname'_fe
}

global depvar_fe zconcep_fe
global treatvar_fe npvm_fe
global control_fe avgnofkids_5_fe   
global incomespec_fe lognetincome_fe

summ npvm_fe zconcep_fe
table mdatgroup, c(mean npvm_fe min npvm_fe max npvm_fe)
table mdatgroup, c(mean zconcep_fe min zconcep_fe max zconcep_fe)
table trisocio, c(mean npvm_fe min npvm_fe max npvm_fe)
table trisocio, c(mean zconcep_fe min zconcep_fe max zconcep_fe)

* =================================================================
* Table 7: The Effect of by Income Category and by Religious Group:
* Mother Fixed Effect and non parametric specification
* =================================================================
* for the whole population
* ========================
xi: reg $depvar_fe $treatvar_fe $control_fe $incomespec_fe $year i.below18*age1 i.below18*age2 i.below18*age3, cluster(agedistyear) robust
estimates store reg, title(nonparam) 
* split by trisocio
* =================
foreach int in 1 2 3 {
	disp `int'
	xi: reg $depvar_fe $treatvar_fe $control_fe $incomespec_fe $year i.below18*age1 i.below18*age2 i.below18*age3 if trisocio==`int' & below18>=2, cluster(agedistyear) robust
 	estimates store regs`int', title(trisocioftrend`int'fe) 
}
* split by Religious groups 
* =========================
foreach int in 1 2 3 4 {
	disp `int'
	xi: reg $depvar_fe $treatvar_fe $control_fe $incomespec_fe $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int' & below18>=2, cluster(agedistyear) robust
 	estimates store regm`int', title(ftrendmdatgroup`int') 
}
xml_tab reg regs1 regs2 regs3 regm1 regm2 regm3 regm4 , stats(N) newappend save("Revise and Resubmit_mfe") title(all mdat inc DE) stats(N r2_p magnitude) sd2 format(Ncc06) sheet(Table7_year_nonparam)
est drop reg regs1 regs2 regs3 regm1 regm2 regm3 regm4 
* ====================================================
* Table 8: The Effect by Income Category and Religion:
* Mother Fixed Effect and non parametric specification
* ====================================================
* split by mdatgroup and by trimsocio 
* ===================================
foreach int in 1 2 3 4 {    
foreach int in 4 {    
	foreach soc in 1 2 3 {
	disp `int'
	disp `soc'
	xi: reg $depvar_fe $treatvar_fe $control_fe $incomespec_fe $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int' & trimsocio==`soc' & below18>=2, cluster(agedistyear) robust
 	estimates store reg`int'`soc', title(`int'`soc')
  }
}
xml_tab reg11  reg12  reg13 reg21  reg22  reg23  reg31  reg32  reg33 reg41 reg42 reg43, stats(N) newappend save("Revise and Resubmit_mfe") title(by mdat trimsoc FE) stats(N r2_p magnitude) sd2 format(Ncc06) sheet(Table8_year_nonparam)
est drop reg11 reg12 reg13 reg21 reg22 reg23 reg31 reg32 reg33 reg41 reg42 reg43
* ====================================================
* Table 9: The Effect by Mother's age:
* Mother Fixed Effect and non parametric specification
* ====================================================
*  split by magegroup 
* ===================
foreach int in 1 2 3 4 5 {
	disp `int'
	xi: reg $depvar_fe $treatvar_fe $control_fe $incomespec_fe $year i.below18*age1 i.below18*age2 i.below18*age3 if magegrp==`int' & below18>=2, cluster(agedistyear) robust
 	estimates store reg`int', title(mage`int')
}
xml_tab reg1  reg2  reg3 reg4  reg5, stats(N) newappend save("Revise and Resubmit_mfe") title(by mdat trimsoc FE) stats(N r2_p magnitude) sd2 format(Ncc06) sheet(Table9_year_nonparam)
est drop reg1 reg2 reg3 reg4 reg5

log close

*=======================================================================================================================================================================
* log using "Final_results_Robustness.smcl", replace
* ==========================================================================================
* ****************  Robustness checks for Revise and Resubmit for RESTAT  ******************
* ==========================================================================================
global depvar zconcep
global treatvar npvm
global control maxedu mdatgroup2-mdatgroup4 avgnofkids_5 
global controladd age1birth mlastbirth mlastbirth2 nofkids
global incomespec lognetincome
global macro uneployper gnpchange
global year year1999 year2000 year2001 year2002 year2003 year2004 year2005
global Jew mmizrachi fmizrachi fnewimmigrant

*=======================================================================================
* Table 13: Robustness Check I: run main speicificaiton with different windows 2002-2004
*=======================================================================================
	* for the whole population
	* ========================
	xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if (yearinc>=2002 & yearinc<=2004), cluster(agedistyear) robust
 	estimates store reg, title(nonparam) 
	* split by trisocio
	* =================
	foreach int in 1 2 3 {
		disp `int'
		xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if trisocio==`int' & (yearinc>=2002 & yearinc<=2004), cluster(agedistyear) robust
 		estimates store regs`int', title(nonparamtrisocio`int') 
	}
	* split by mdatgroup levels 
	* =========================
	foreach int in 1 2 3 {
		disp `int'
		xi: reg $depvar $treatvar $control $Jew $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int' & (yearinc>=2002 & yearinc<=2004), cluster(agedistyear) robust
 		estimates store regm`int', title(ftrendmdatgroup`int') 
	}
	foreach int in 4 {
		disp `int'
		xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int' & (yearinc==2002 | yearinc==2005), cluster(agedistyear) robust
 		estimates store regm`int', title(ftrendmdatgroup`int')
	}

	xml_tab reg regs1 regs2 regs3 regm1 regm2 regm3 regm4, stats(N) newappend save("Revise and Resubmit_window") title(yearinc>=2002|yearinc==2005) stats(N r2_p) sd2 format(Ncc06)  sheet (TableRobust2002or2005)
	est drop reg regs1 regs2 regs3 regm1 regm2 regm3 regm4


summ $depvar if (yearinc>=2002 & yearinc<=2004)
table trisocio if (yearinc>=2002 & yearinc<=2004), c(mean $depvar)
table mdatgroup if (yearinc>=2002 & yearinc<=2004), c(mean $depvar)

* =====================================================================
* Table 14: Robustness Check II: run main speicificaiton with new CA PV 
* =====================================================================

* 3 scenarios: npvm1 (adaptive), npvm2 (AR1) and npvm3 (lag)
* Need to merge with npv_ada_ar1_lag.dta
sort ficzehut yearinc
merge ficzehut yearinc using npv_ada_ar1_lag.dta
tab _merge

global depvar zconcep
global control maxedu mdatgroup2-mdatgroup4 avgnofkids_5 
global incomespec lognetincome
global year year1999 year2000 year2001 year2002 year2003 year2004 year2005
global Jew mmizrachi fmizrachi fnewimmigrant

gen npvm1=npvada/12.27 
gen npvm2=npvar1/12.27 
gen npvm3=npvlag/12.27 

table mdatgroup, c(mean npvm mean npvm1 mean npvm2 mean npvm3)
table yearinc mdatgroup, c(mean npvm mean npvm1 mean npvm2 mean npvm3)
table trisocio, c(mean npvm mean npvm1 mean npvm2 mean npvm3)
table yearinc trisocio, c(mean npvm mean npvm1 mean npvm2 mean npvm3)

forval var=1/3 {
	* for the whole population
	* ========================
		xi: reg $depvar npvm`var' $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3, cluster(agedistyear) robust
		estimates store reg, title(nonparam) 
	* split by trisocio
	* =================
	foreach int in 1 2 3 {
		disp `int'
		xi: reg $depvar npvm`var' $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if trisocio==`int', cluster(agedistyear) robust
		estimates store regs`int', title(nonparamtrisocio`int') 
	}
	* split by mdatgroup levels 
	* =========================
	foreach int in 1 2 3 {
		disp `int'
		xi: reg $depvar npvm`var' $control $Jew $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int', cluster(agedistyear) robust
		estimates store regm`int', title(ftrendmdatgroup`int') 
	}
	foreach int in 4 {
		disp `int'
		xi: reg $depvar npvm`var' $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if mdatgroup==`int', cluster(agedistyear) robust
		estimates store regm`int', title(ftrendmdatgroup`int')
	}
	xml_tab reg regs1 regs2 regs3 regm1 regm2 regm3 regm4, stats(N) newappend save("Revise and Resubmit_3scenarios") title(npvm`var') stats(N r2_p) sd2 format(Ncc06) sheet(TableRobustnpvm`var')
	est drop reg regs1 regs2 regs3 regm1 regm2 regm3 regm4
}

* ===========================================================================
* Table 15: Robustness Check III: Total number of kids
* ==========================================
* regress total number of kids for year 1999-2000 for women 40+
* predicy total number of kids for women 30-35+
* arrange in quintiles and regress main specification again for each quintile
* ===========================================================================

reg nofkids $control $incomespec if (mage>40) & (yearinc==1999|yearinc==2000), cluster(agedistyear) robust
estimates store reg, title(nonparam) 
predict pnofkids30 if yearinc>=2001 & (mage>30 & mage<=35)

centile pnofkids30, c(33 66)
gen pkidsg_30=1 if pnofkids30<r(c_1)
replace pkidsg_30=2 if pnofkids30>=r(c_1) & pnofkids30<r(c_2)
replace pkidsg_30=3 if pnofkids30>=r(c_2) & pnofkids30~=.

table pkidsg_30, c(mean $depvar count mage)

forval int=1/3 {
	xi: reg $depvar $treatvar $control $incomespec $year i.below18*age1 i.below18*age2 i.below18*age3 if pkidsg_30==`int', cluster(agedistyear) robust
	estimates store reg`int', title(mfe`int') 
}
xml_tab reg reg1 reg2 reg3, stats(N) newappend save("Revise and Resubmit_robust") title(kids quarter) stats(N r2_p) sd2 format(Ncc06)  sheet(TableRobustkidstri)
est drop reg reg1 reg2 reg3

drop pkidsg_30 pnofkids30

log close
