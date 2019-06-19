clear
set more off
cd C:\NBB\Projects\ECB\Data\
qui cap log close
qui log using  C:\NBB\Projects\ECB\PROD_analysisDD.log, replace


************************Build trade data for 07-09******************************************

cd C:\NBB\Projects\ECB\

	use Data\ixd_1_trim_2007.dta, clear
	append using Data\ixd_2_trim_2007.dta
	append using Data\ixd_1_trim_2008.dta
	append using Data\ixd_2_trim_2008.dta
	append using Data\ixd_1_trim_2009.dta
	append using Data\ixd_2_trim_2009.dta


	gen chow = 1 if  ///
		 	 nature == "1" | nature == "11" | nature == "12" | nature == "13" | nature == "14" | nature == "15" | nature == "16" | nature == "17" | ///
			 nature == "18" | nature == "19"  | ///
			 nature == "3" | nature == "31" | nature == "32" | nature == "33" | nature == "34" | nature == "35" | nature == "36" | nature == "37" | ///
			 nature == "38" | nature == "39"  | ///
			 nature == "7" | nature == "71" | nature == "72" | nature == "73" | nature == "74" | nature == "75" | nature == "76" | nature == "77" | ///
			 nature == "78" | nature == "79"  | ///
			 nature ==  "8" | nature ==  "81" | nature ==  "82" | nature ==  "83" | nature ==  "84" | nature ==  "85" | nature ==  "86" | ///
			 nature == "87" | nature ==  "88" | nature ==  "89"
	
	qui count if chow == 1
	
	*******keeping only those transactins involving changes in ownerships*****
	keep if chow == 1 
	drop chow
	***********	
	**Eliminating some unuseful codes 
	
	drop if  land == "EU" |land == "II" | land == "BE" |land == "XX" | land == "QQ" | land == "QU" | land =="QX" |  land =="QY" |  land =="QZ" | land =="XN" |  land =="XU" |  land =="XV" |  land =="XW" |  land =="XS" |  land =="XR" |  land =="XQ" |  land =="XP" |  land =="XO" |  land =="XT"   

	*****************
	
	replace flow="EXP" if flow=="XE"
	replace flow="EXP" if flow=="XI"
	replace flow="IMP" if flow=="IE"
	replace flow="IMP" if flow=="II"


	***drop trade by non residents********


	sort vat year
	merge vat year using Data\Non_residents_year_2007.dta
	drop if _merge==2
	drop _merge
	gen keep=1
	replace keep=0 if resd!=""
	drop  resd


	sort vat year
	merge vat year using Data\Non_residents_year_2008.dta
	drop if _merge==2
	drop _merge
	replace keep=0 if resd!=""
	drop  resd

	sort vat year
	merge vat year using Data\Non_residents_year_2009.dta
	drop if _merge==2
	drop _merge
	replace keep=0 if resd!=""
	drop  resd

	keep if keep==1


	collapse (sum)  value , by( year vat flow) 
	tostring year, generate(pippo)
	tostring vat, generate(pippa)
	egen fake=concat(pippo pippa)
	drop vat year pippa pippo
	reshape wide  value, i(fake) j(flow) string
	gen year=substr(fake,1,4)
	destring year, replace
	gen vat=substr(fake,5,9)
	destring vat, replace
	drop fake
	order vat year
	sort vat year
	save trade_for_VAT.dta, replace



	**********************Analysis****************************
	**********************Analysis****************************
	**********************Analysis****************************
	use trade_for_VAT.dta, clear
	merge  vat year using data\prodcom_firm_1st_semester.dta
	drop if _merge==2
	drop _merge
	sort vat year	
	save temp.dta, replace

	use temp.dta, clear
	keep if year==2007
	sort vat
	merge vat using Data\firm_data_07_08.dta
	drop if _merge==2
	drop _merge
	save temp2.dta, replace


	use temp.dta, clear
	drop if year==2007
	sort vat
	merge vat using Data\firm_data.dta
	drop if _merge==2
	drop _merge
	recode  r_*  for mne (1=.) if year==2009
	recode  r_*  for mne (0=.) if year==2009
	replace nace2=. if year==2009
	
	append using temp2.dta
	erase temp.dta
	erase temp2.dta

	sort vat year
	egen pippo=count(year), by(vat)
	drop if  pippo==4 & r_size==.
	xtset vat year


	gen pippo_exp=log(valueEXP/prod_value)

	gen ratio_exp=f1.pippo_exp-pippo_exp 
	gen pippi_exp=0
	replace pippi_exp=1 if (r_size + r_prod + r_interm_share + r_share_exp_sales + r_share_imp_interm + r_value_add_chain +  r_ext_fin_dep + r_share_debts_o_passive + r_share_debts_due_after_one + r_share_fin_debt + r_share_stock + for + mne + nace2 +  ratio_exp) != .

	su ratio_exp if  pippi_exp==1 &  ratio_exp!=. & year==2007, de
	su ratio_exp if  pippi_exp==1 &  ratio_exp!=. & year==2008, de
	su pippo_exp if  pippi_exp==1 &  ratio_exp!=. & year==2007, de
	su pippo_exp if  l1.pippi_exp==1 &  l1.ratio_exp!=. & year==2008, de
	su pippo_exp if  pippi_exp==1 &  ratio_exp!=. & year==2008, de
	su pippo_exp if  l1.pippi_exp==1 &  l1.ratio_exp!=. & year==2009, de
	corr pippo_exp f1.pippo_exp if pippi_exp==1 &  ratio_exp!=. & year==2007
	corr pippo_exp f1.pippo_exp if pippi_exp==1 &  ratio_exp!=. & year==2008


	gen pippo_imp=log(valueIMP/  prod_value)

	gen ratio_imp=f1.pippo_imp-pippo_imp 
	gen pippi_imp=0
	replace pippi_imp=1 if (r_size + r_prod + r_interm_share + r_share_exp_sales + r_share_imp_interm + r_value_add_chain +  r_ext_fin_dep + r_share_debts_o_passive + r_share_debts_due_after_one + r_share_fin_debt + r_share_stock + for + mne + nace2 +  ratio_imp) != .

	su ratio_imp if  pippi_imp==1 &  ratio_imp!=. & year==2007, de
	su ratio_imp if  pippi_imp==1 &  ratio_imp!=. & year==2008, de
	su pippo_imp if  pippi_imp==1 &  ratio_imp!=. & year==2007, de
	su pippo_imp if  l1.pippi_imp==1 &  l1.ratio_imp!=. & year==2008, de
	su pippo_imp if  pippi_imp==1 &  ratio_imp!=. & year==2008, de
	su pippo_imp if  l1.pippi_imp==1 &  l1.ratio_imp!=. & year==2009, de
	corr pippo_imp f1.pippo_imp if pippi_imp==1 &  ratio_imp!=. & year==2007
	corr pippo_imp f1.pippo_imp if pippi_imp==1 &  ratio_imp!=. & year==2008


	xi i.nace2, pre(nace)
	gen  nacenace2_1=0
	replace  nacenace2_1=1 if nace2==1
	drop nacenace2_34
*	we take automobile as reference


	gen crisis=.
	replace crisis=0 if year==2007
	replace crisis=1 if year==2008

	generate is_nace2=nace2*crisis

	generate i_r_size=r_size*crisis
	generate i_r_prod=r_prod*crisis
	generate i_r_interm_share=r_interm_share*crisis
	generate i_r_share_exp_sales=r_share_exp_sales*crisis
	generate i_r_share_imp_interm=r_share_imp_interm*crisis
	generate i_r_value_add_chain=r_value_add_chain*crisis
	generate i_r_ext_fin_dep=r_ext_fin_dep*crisis
	generate i_r_share_debts_o_passive=r_share_debts_o_passive*crisis
	generate i_r_share_debts_due_after_one=r_share_debts_due_after_one*crisis
	generate i_r_share_fin_debt=r_share_fin_debt*crisis
	generate i_r_share_stock=r_share_stock*crisis
	generate i_for=for*crisis
	generate i_mne=mne*crisis
	

	xi i.is_nace2, pre(is_n)
	drop  is_nis_nace_34
	*we take automobile as reference

	local instruct "tex tdec(4) rdec(4) auto(4) bdec (4) symbol($^a$,$^b$,$^c$)  se"
	local firm_var " r_size r_prod  r_interm_share  r_share_exp_sales  r_share_imp_interm r_value_add_chain r_ext_fin_dep r_share_debts_o_passive r_share_debts_due_after_one r_share_fin_debt r_share_stock for mne"
	local inter "i_*"
	local dummies "  nacenace2_*  is_nis_nace_*"


	xi: regress  ratio_exp crisis `firm_var' `inter' `dummies' , cluster(vat)
	outreg2 `firm_var' `inter' `dummies' using Results/table_PROD_DD.xls,ctitle(exports)  `instruct' replace
	xi: regress  ratio_imp crisis `firm_var' `inter' `dummies' , cluster(vat)
	outreg2 `firm_var' `inter' `dummies' using Results/table_PROD_DD.xls,ctitle(imports)  `instruct' append


	local instruct "tex tdec(4) rdec(4) auto(4) bdec (4) symbol($^a$,$^b$,$^c$)  se"
	local firm_var " r_size r_prod  r_interm_share  r_share_exp_sales  r_share_imp_interm r_value_add_chain r_ext_fin_dep r_share_debts_o_passive r_share_debts_due_after_one r_share_fin_debt r_share_stock for mne"
	local inter "i_*"
	local dummies "  nacenace2_*  is_nis_nace_*"

	gen peso_exp=log( prod_value+1) if pippo_exp!=.
	gen peso_imp=log( prod_value+1) if pippo_imp!=.

	xi: regress  ratio_exp crisis `firm_var' `inter' `dummies' [pweight=(peso_exp)], cluster(vat)
	outreg2 `firm_var' `inter' `dummies' using Results/table_PROD_DD.xls,ctitle(exports WLS)  `instruct' append
	xi: regress  ratio_imp crisis `firm_var' `inter' `dummies' [pweight=(peso_imp)], cluster(vat)
	outreg2 `firm_var' `inter' `dummies' using Results/table_PROD_DD.xls,ctitle(imports WLS)  `instruct' append



log close