set more off


  *************************************************************************
  *  NAME: 	conf_pref_ReSTAT.do											  *
  *																		  *  
  *  GOAL:Create table replication files for "Impact of Violent Crime on  *		
  *     Risk Aversion: Evidence from the Mexican Drug War"                *
  *     by Ryan Brown, Veronica Montalva,                                 *
  *	    Duncan Thomas and Andrea Velasquez                                *
  *																		  *
  *  OUTPUT: .do file produces Table1.out-Table5.out                      *	
  *  NOTES: Requires the following add-on command:						  *
  *				1. outreg2 	                                              *
  *				2. tabout										          *
  *			Steps to install this through the Boston College Statistical  *
  *				Software Components Archive (SSC) are included in the     *
  *				preamble as "ssc install ..." Note that these require an  *
  *				internet connection to access SSC.				          *													  
  ************************************************************************* 
 
  ************************************************************************* 
 
  *************************************************************************

local dataset_ReSTAT conf_pref_ReSTAT.dta

use `dataset_ReSTAT', clear

*****installs "outreg2" if needed********
  ssc install outreg2 
  ssc install tabout 
  

*----setting homicide rate

local hom hr 

*----setting risk aversion outcome
local outcome m1risk2av


*--- Control variables

******setting RHS control variables for Tables 2-5 *****
	local cntr_p	"married_p nchild_p 	yeduc_p emp_p self_p qrearn_p 	hhsize_p ohhm_kids_p 	qrpce_p rural_p scared_night_p"	
	local cntr_p_M	"married_p_M nchild_p_M emp_p_M self_p_M yeduc_p_M qrearn_p_M qrpce_p_M scared_night_p_M"	

******setting interview date and survey wave fixed effects for Tables 2-5*****
	local ivwfe	"i.wave i.mes_int i.ano_int"

******setting individual indicator*****
xtset unique_id


*------------------------------------------------*
* TABLE 1
*------------------------------------------------*
    
    preserve
	******drop observations missing risk aversion measure*******
	keep if `outcome'~=.
	******create balanced sample*******
	bysort unique_id: gen N=_N
	drop if N==1
	drop N
	
	qui tabout risk2 if wave==5 using Table_1.out, replace cells(freq col)
	qui tabout risk2 if wave==9 using Table_1.out, append cells(freq col)
		
	
*------------------------------------------------------------------*
* TABLE 2 
*------------------------------------------------------------------*	

*--- Regressions

	qui reg    `outcome'  `hom'  `cntr_p' `ivwfe' `cntr_p_M' if wave==5, cluster(mpio05_id)
    egen mean_dep=mean(`e(depvar)') if e(sample)
    outreg2 using Table_2.out,  keep(`hom') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Mean dep. variable,mean_dep) ctitle(column 1)  se replace
	drop mean_dep
	
	qui reg    `outcome'  `hom'  `cntr_p' `ivwfe' `cntr_p_M' if wave==9, cluster(mpio05_id)
    egen mean_dep9=mean(`e(depvar)') if e(sample)
    egen mean_dep=min(mean_dep9)
    outreg2 using Table_2.out,  keep(`hom') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Mean dep. variable,mean_dep) ctitle(column 2)  se append
	drop mean_dep*
	
	qui xtreg  `outcome'  `hom'  `cntr_p' `ivwfe' `cntr_p_M', fe cluster(mpio05_id)
    egen mean_dep=mean(`e(depvar)') if e(sample)
    outreg2 using Table_2.out,  keep(`hom') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Mean dep. variable,mean_dep) ctitle(column 3)  se append
	drop mean_dep

	qui xtreg  `outcome'  `hom'  `cntr_p' `ivwfe' `cntr_p_M' i.mpio_id ,   fe cluster(mpio05_id)
    egen mean_dep=mean(`e(depvar)') if e(sample)
    outreg2 using Table_2.out,  keep(`hom') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Mean dep. variable,mean_dep) ctitle(column 4)  se append
    outreg2 using Table_3.out,  keep(`hom') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Mean dep. variable, mean_dep) ctitle(column 1)  se replace
	outreg2 using Table_5.out,  keep(`hom') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Mean dep. variable, mean_dep) ctitle(column 1)  se replace
	drop mean_dep
*------------------------------------------------------------------*
* TABLE 3 
*------------------------------------------------------------------*	
	local column_dmale column 2
	local column_age_05 column 3
	local column_rural_05 column 4
	local column_yeduc_05_B25 column 5
	local column_qrpce_05_B25 column 6
	local column_self_05 column 7

*************************
******Column 2 **********
*************************

	foreach var in dmale {

******setting interaction group*******
	local strat `var'
******creating interactions of RHS variables*******
	local Xs_strat `strat'#c.married_p `strat'#c.nchild_p `strat'#c.yeduc_p `strat'#c.emp_p `strat'#c.self_p `strat'#c.qrearn_p `strat'#c.hhsize_p `strat'#c.ohhm_kids_p `strat'#c.qrpce_p `strat'#c.rural_p `strat'#c.scared_night_p `strat'#c.married_p_M `strat'#c.nchild_p_M `strat'#c.emp_p_M `strat'#c.self_p_M `strat'#c.yeduc_p_M `strat'#c.qrearn_p_M  `strat'#c.qrpce_p_M `strat'#c.scared_night_p_M

	gen hom_`strat'=`hom'*`strat'

*--- Regressions
	
	qui xtreg  `outcome'  `hom'  hom_`strat' `strat' `cntr_p' `cntr_p_M'  `Xs_strat' `ivwfe' i.wave#`strat' i.ano_int#`strat' i.mes_int#`strat' i.mpio_id i.mpio_id#`strat' ,     fe cluster(mpio05_id)
	egen mean_dep=mean(`e(depvar)') if e(sample)
	test `hom'=-hom_`strat'
	local test1=r(p)
	outreg2 using Table_3.out, keep(`hom' hom_`strat') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Hom Rate + Hom Rate Interaction=0,`test1', Mean dep. variable, mean_dep) ctitle(`column_`var'')  se append
	drop mean_dep
	}

*************************
******Column 3 **********
*************************
	
	foreach var in age_05 {

	*--- Regression
******setting interaction group*******
	local strat `var'
******creating interactions of RHS variables*******
	local Xs_strat c.`strat'#c.married_p c.`strat'#c.nchild_p c.`strat'#c.yeduc_p c.`strat'#c.emp_p c.`strat'#c.self_p c.`strat'#c.qrearn_p c.`strat'#c.hhsize_p c.`strat'#c.ohhm_kids_p c.`strat'#c.qrpce_p c.`strat'#c.rural_p c.`strat'#c.scared_night_p c.`strat'#c.married_p_M c.`strat'#c.nchild_p_M c.`strat'#c.emp_p_M c.`strat'#c.self_p_M c.`strat'#c.yeduc_p_M c.`strat'#c.qrearn_p_M  c.`strat'#c.qrpce_p_M c.`strat'#c.scared_night_p_M

	gen hom_`strat'=`hom'*`strat'

*--- Regressions
		
	qui xtreg  `outcome'  `hom'  hom_`strat' `strat' `cntr_p' `cntr_p_M'  `Xs_strat' `ivwfe' i.wave#c.`strat' i.ano_int#c.`strat' i.mes_int#c.`strat' i.mpio_id i.mpio_id#c.`strat'   ,     fe cluster(mpio05_id)
	egen mean_dep=mean(`e(depvar)') if e(sample)
	test `hom'=-hom_`strat'
	local test1=r(p)
	outreg2 using Table_3.out, keep(`hom' hom_`strat') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Hom Rate + Hom Rate Interaction=0,`test1', Mean dep. variable, mean_dep) ctitle(`column_`var'')  se append
	drop mean_dep
	}
	

*************************
******Columns 4-7 *******
*************************	

	foreach var in rural_05 yeduc_05_B25 qrpce_05_B25 self_05 {

******setting interaction group*******
	local strat `var'
******creating interactions of RHS variables*******
	local Xs_strat `strat'#c.married_p `strat'#c.nchild_p `strat'#c.yeduc_p `strat'#c.emp_p `strat'#c.self_p `strat'#c.qrearn_p `strat'#c.hhsize_p `strat'#c.ohhm_kids_p `strat'#c.qrpce_p `strat'#c.rural_p `strat'#c.scared_night_p `strat'#c.married_p_M `strat'#c.nchild_p_M `strat'#c.emp_p_M `strat'#c.self_p_M `strat'#c.yeduc_p_M `strat'#c.qrearn_p_M  `strat'#c.qrpce_p_M `strat'#c.scared_night_p_M

	gen hom_`strat'=`hom'*`strat'

*--- Regressions
	
	qui xtreg  `outcome'  `hom'  hom_`strat' `strat' `cntr_p' `cntr_p_M'  `Xs_strat' `ivwfe' i.wave#`strat' i.ano_int#`strat' i.mes_int#`strat' i.mpio_id i.mpio_id#`strat' ,     fe cluster(mpio05_id)
	egen mean_dep=mean(`e(depvar)') if e(sample)
	test `hom'=-hom_`strat'
	local test1=r(p)
	outreg2 using Table_3.out, keep(`hom' hom_`strat') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Hom Rate + Hom Rate Interaction=0,`test1', Mean dep. variable, mean_dep)  ctitle(`column_`var'')  se append
	drop mean_dep
	}
	
	
	restore
	
*------------------------------------------------------------------*
* TABLE 4 
*------------------------------------------------------------------*	

		
	local column_emp_100 column 1
	local column_qrpce_B25_100 column 2
	local column_quar_smtot2 column 3
	local column_bp_sys_alt column 4
	local column_safe_c5_less_100 column 5
	local column_scared_night_100 column 6

*************************
******Column 1 **********
*************************

	foreach var in emp_100 {
	preserve
	******drop observations missing value for dependent variable*******
	keep if `var'~=.
	******create balanced sample*******
	bysort unique_id: gen N=_N
	drop if N==1
	drop N

*--- Regressions

	qui xtreg  `var'  `hom'  `cntr_p' `ivwfe' `cntr_p_M' i.mpio_id ,   fe cluster(mpio05_id)
    egen mean_dep=mean(`e(depvar)') if e(sample)
    outreg2 using Table_4.out,  keep(`hom') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Mean dep. variable, mean_dep) ctitle(`column_`var'')  se replace
   	drop mean_dep
	restore
	}

*************************
******Columns 2-6 *******
*************************
	
	foreach var in qrpce_B25_100 quar_smtot2 bp_sys_alt safe_c5_less_100 scared_night_100 {
	preserve
	******drop observations missing value for dependent variable*******
	keep if `var'~=.
	******create balanced sample*******
	bysort unique_id: gen N=_N
	drop if N==1
	drop N

*--- Regressions

	qui xtreg  `var'  `hom'  `cntr_p' `ivwfe' `cntr_p_M' i.mpio_id ,   fe cluster(mpio05_id)
    egen mean_dep=mean(`e(depvar)') if e(sample)
    outreg2 using Table_4.out,  keep(`hom') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Mean dep. variable, mean_dep) ctitle(`column_`var'')  se append
   	drop mean_dep
	restore
	}
	
	
	
*------------------------------------------------------------------*
* TABLE 5 
*------------------------------------------------------------------*	
	local column_emp column 2
	local column_qrpce0509_B25 column 3
	local column_quar_smtot2 column 4
	local column_bp_sys_alt column 5
	local column_safe_c5_less column 6
	local column_scared_night column 7

*************************
******Columns 2-3 *******
*************************

	foreach var in emp qrpce0509_B25{
	preserve
	******drop observations missing value for dependent variable and mediator*******
	keep if `outcome'~=.
	keep if `var'~=.
	******create balanced sample*******
	bysort unique_id: gen N=_N
	drop if N==1
	drop N

******setting interaction group*******
	local strat `var'
******creating interactions of RHS variables*******
	local Xs_strat `strat'#c.married_p `strat'#c.nchild_p `strat'#c.yeduc_p `strat'#c.emp_p `strat'#c.self_p `strat'#c.qrearn_p `strat'#c.hhsize_p `strat'#c.ohhm_kids_p `strat'#c.qrpce_p `strat'#c.rural_p `strat'#c.scared_night_p `strat'#c.married_p_M `strat'#c.nchild_p_M `strat'#c.emp_p_M `strat'#c.self_p_M `strat'#c.yeduc_p_M `strat'#c.qrearn_p_M  `strat'#c.qrpce_p_M `strat'#c.scared_night_p_M

	gen hom_`strat'=`hom'*`strat'
	
	qui xtreg  `outcome'  `hom'  hom_`strat' `strat' `cntr_p' `cntr_p_M'  `Xs_strat' `ivwfe' i.wave#`strat' i.ano_int#`strat' i.mes_int#`strat' i.mpio_id i.mpio_id#`strat' ,     fe cluster(mpio05_id)
	egen mean_dep=mean(`e(depvar)') if e(sample)
	test `hom'=-hom_`strat'
	local test1=r(p)
	outreg2 using Table_5.out, keep(`hom' hom_`strat') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Hom Rate + Hom Rate Interaction=0,`test1', Mean dep. variable, mean_dep) ctitle(`column_`var'')  se append
	drop mean_dep
	restore
	}
	
*************************
******Columns 4-5 *******
*************************
	
	foreach var in quar_smtot2 bp_sys_alt {
	preserve
	******drop observations missing value for dependent variable and mediator*******
	keep if `outcome'~=.
	keep if `var'~=.
	******create balanced sample*******
	bysort unique_id: gen N=_N
	drop if N==1
	drop N

******setting interaction group*******
	local strat `var'
******creating interactions of RHS variables*******
	local Xs_strat c.`strat'#c.married_p c.`strat'#c.nchild_p c.`strat'#c.yeduc_p c.`strat'#c.emp_p c.`strat'#c.self_p c.`strat'#c.qrearn_p c.`strat'#c.hhsize_p c.`strat'#c.ohhm_kids_p c.`strat'#c.qrpce_p c.`strat'#c.rural_p c.`strat'#c.scared_night_p c.`strat'#c.married_p_M c.`strat'#c.nchild_p_M c.`strat'#c.emp_p_M c.`strat'#c.self_p_M c.`strat'#c.yeduc_p_M c.`strat'#c.qrearn_p_M  c.`strat'#c.qrpce_p_M c.`strat'#c.scared_night_p_M

	gen hom_`strat'=`hom'*`strat'
		
	qui xtreg  `outcome'  `hom'  hom_`strat' `strat' `cntr_p' `cntr_p_M'  `Xs_strat' `ivwfe' i.wave#c.`strat' i.ano_int#c.`strat' i.mes_int#c.`strat' i.mpio_id i.mpio_id#c.`strat'   ,     fe cluster(mpio05_id)
	egen mean_dep=mean(`e(depvar)') if e(sample)
	test `hom'=-hom_`strat'
	local test1=r(p)
	outreg2 using Table_5.out, keep(`hom' hom_`strat') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Hom Rate + Hom Rate Interaction=0,`test1', Mean dep. variable, mean_dep) ctitle(`column_`var'')  se append
	drop mean_dep
	restore
	}
		

*************************
******Columns 6-7 *******
*************************
	
	foreach var in safe_c5_less scared_night {
	preserve
	******drop observations missing value for dependent variable and mediator*******
	keep if `outcome'~=.
	keep if `var'~=.
	******create balanced sample*******
	bysort unique_id: gen N=_N
	drop if N==1
	drop N

******setting interaction group*******
	local strat `var'
******creating interactions of RHS variables*******
	local Xs_strat `strat'#c.married_p `strat'#c.nchild_p `strat'#c.yeduc_p `strat'#c.emp_p `strat'#c.self_p `strat'#c.qrearn_p `strat'#c.hhsize_p `strat'#c.ohhm_kids_p `strat'#c.qrpce_p `strat'#c.rural_p `strat'#c.scared_night_p `strat'#c.married_p_M `strat'#c.nchild_p_M `strat'#c.emp_p_M `strat'#c.self_p_M `strat'#c.yeduc_p_M `strat'#c.qrearn_p_M  `strat'#c.qrpce_p_M `strat'#c.scared_night_p_M

	gen hom_`strat'=`hom'*`strat'
	
	qui xtreg  `outcome'  `hom'  hom_`strat' `strat' `cntr_p' `cntr_p_M'  `Xs_strat' `ivwfe' i.wave#`strat' i.ano_int#`strat' i.mes_int#`strat' i.mpio_id i.mpio_id#`strat' ,     fe cluster(mpio05_id)
	egen mean_dep=mean(`e(depvar)') if e(sample)
	test `hom'=-hom_`strat'
	local test1=r(p)
	outreg2 using Table_5.out, keep(`hom' hom_`strat') bracket symbol(***, **, *) nor2 nocons  dec(5) addstat(Hom Rate + Hom Rate Interaction=0,`test1', Mean dep. variable, mean_dep) ctitle(`column_`var'')  se append
	drop mean_dep
	restore
	}
	
	
	
	