* Review of Economics and Statistics MS 17989

/*

This Stata(12) program creates all of the tables and figuresreported in the Internet Appendix of:

  - Agarwal, Sumit, and Wenlan Qian. January 2016. "Access to Home Equity and Consumption:
	Evidence from a Policy Experiment" 

Data: Due to confidentially agreements with the data providers, the data used in this 
	analysis is not available for public distribution. We will store the data at NUS 
	and any researcher can come and access the data on a stand-alone computer for 
	replication and validation purposes.  
	
Data files for the anlaysis: 
	HousingConsumption_final.dta: the sample data of Singaporeans living in HDB market 
	HousingConsumption_matched.dta:  matched sample of married and single Singaporeans living in HDB market
	HousingConsumption_private.dta: sample of Singaporeans living in the private market; for falsification test 1
	HousingConsumption_foreigner.dta: sample of non-pr foreigners liviing in HDB; for falsification test 2
	
Attached raw data for plotting Figure IA.3 Panel B: HDB_resale_price.xlsx
	Data is obtained from publicly available source (www.hdb.gov.sg)
	
Key regressors:
	(log)totspend: (natural logarithem of) total monthly spending on debit and credit cards at the individual level
	(log)debitspend: (natural logarithem of) total monthly spending on debit cards at the individual level
	(log)totccspend: (natural logarithem of) total monthly spending on credit cards at the individual level
	
Other Key variables:
	cinmask: unique identifier for each consumer
	post_yrmo: identifier for each year-month in a given postal sector
	
	premarried: treatment dummy, = 1 if the consumer is married (as of the pre-policy period), 0 otherwise
	premarried_aft: = 1 for consumers in the treatment group in months after 2010:08, and 0 otherwise
	premarried_pre: = 1 for consumers in the treatment group between 2010:05 and 2010:08, and 0 otherwise

	female: = 1 for female, 0 otherwise
	chinese:  = 1 for ethnically Chinese, 0 otherwise
	preinc: the average income in the pre-policy period 
	prebal: the average checking account balance in the pre-policy period
	preage: age (in years) as of 2010:08		
*/

global outputdir "`where you save the results'"
global workdir "`where the test data are placed'"

***************************************
******	Table IA.1
***************************************  
** controlling for region-specific time fixed effects
use "$workdir\HousingConsumption_final", clear
	
	xi:areg logtotspend premarried_aft  premarried_pre i.post_yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia1", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending") replace
	xi:areg logtotccspend premarried_aft premarried_pre  i.post_yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia1", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log credit card spending") 
	xi:areg logdebitspend premarried_aft  premarried_pre i.post_yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia1", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending")


***************************************
******	Table IA.2
*************************************** 
** alternative treatment and control (<35)
use "$workdir\HousingConsumption_final", clear

	keep if preage<35
	
	xi:areg logtotspend premarried_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia2", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending") replace
	xi:areg logtotccspend premarried_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia2", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log credit card spending") 
	xi:areg logdebitspend premarried_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia2", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 
			
***************************************
******	Table IA.3
***************************************
** matched sample analysis   
use "$workdir\HousingConsumption_matched", clear

	duplicates drop cinmask, force	
	** comparison after match
	log using "$outputdir\Tableia3a.log", replace
		ttest preinc, by(premarried)
		ttest prebal, by(premarried)
		ttest preage, by(premarried)
		ttest chinese, by(premarried)
		ttest female, by(premarried)
	log close

use "$workdir\HousingConsumption_matched", clear

	xi:areg logtotspend premarried_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia3b", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending") replace
	xi:areg logtotccspend premarried_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia3b", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log credit card spending")
	xi:areg logdebitspend premarried_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia3b", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 
	
 
***************************************
******	Table IA.4
***************************************	
** Falsification tests	

** private housing
use "$workdir\HousingConsumption_private", clear
	
	xi:areg logtotspend premarried_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia4", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*)  replace

** foreigners in HDB
use "$workdir\HousingConsumption_foreigner", clear
			
	xi:areg logtotspend premarried_aft premarried_pre  i.yrmo if pr==0, abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Tableia4", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) 

** Small sample
	local i = 1
	while `i' < 101{
		use "$workdir\HousingConsumption_final", clear
			
		gen temp1=runiform() 
		sort cinmask yrmo 
		gen temp2=cinmask!=cinmask[_n-1] 
		gen temp3=temp1*temp2
		bysort cinmask : egen temp4=max(temp3)
		keep if temp4<0.2
		**
		
		xi:areg logtotspend premarried_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		matrix b = e(b)
		matrix ob = e(N)
		if `i'==1 matrix betas=b
			else matrix betas=(betas \ b)
		if `i'==1 matrix obs=ob
			else matrix obs=(obs \ ob)
		if `i' == 1 log using "$outputdir\Table1a4.log",replace
			else log using "$outputdir\Table1a4.log",append
		lincom premarried_aft
		log close
		if `i' == 1 log using"$outputdir\Table1a4.log",replace
			else log using "$outputdir\Table1a4.log",append
		lincom premarried_pre
		log close
		local i = `i'  + 1
		}
		
		svmat obs
		sum obs*
		svmat betas
		ttest betas1 ==0 
		ttest betas2 ==0
		
***************************************
******	Figure IA.2
***************************************	
** Unconditional Spending Response Dynamics		
use "$workdir\HousingConsumption_final", clear
		
	bysort yrmo premarried : egen ts_tot=mean(totspend)
	bysort yrmo premarried : egen ts_totcc=mean(totccspend)
	bysort yrmo premarried : egen ts_totdb=mean(debitspend)

	sort yrmo premarried cinmask
	drop if premarried==premarried[_n-1] & yrmo==yrmo[_n-1]

	sort premarried yrmo
	keep ts* yrmo premarried
	export excel using "$outputdir\Figureia2.xlsx", sheet("unconditional") firstrow(variables) sheetmodify

***************************************
******	Figure IA.3 Panel B
***************************************	
** Average price growth in 2007-2009 by postal sector
** original transaction data obtained from HDB
** http://www.hdb.gov.sg

import excel "$workdir\HDB_resale_price.xlsx", sheet("price") firstrow clear

	** restrict to years before the policy
	drop if year>2009
	
	** mean resale price at the district level
	bysort district_code year: egen meanprice_ann = mean(resale_price)
	
	** collapse at the district year level
	duplicates drop district_code year, force
	
	** average price growth by district up till 2009
	gen lnprice = ln(meanprice_ann)
	sort district_code year
	gen pricegrowth_ann = 100*(lnprice - lnprice[_n-1]) if district_code == district_code[_n-1]
	bysort district_code: egen avepricegrowth = mean(pricegrowth_ann)
	** average growth rate during the three  years before
	bysort district_code: egen temp = mean(pricegrowth_ann) if year>2006
	bysort district_code: egen avepricegrowth_3yr = max(temp)
	drop temp
	
	** collapse at the district level
	duplicates drop district_code, force
	drop if avepricegrowth_3yr==.
	
	keep district_code avepricegrowth_3yr
	destring district_code, g(postcode_reg)
	drop district_code
	
	sort postcode_reg
	export excel using "$outputdir\Figureia3.xlsx", sheet("avepricegrowth") firstrow(variables) sheetmodify
