* Review of Economics and Statistics MS 17989

/*

This Stata(12) program creates all of the tables, figures, and numbers reported in the texts of:

  - Agarwal, Sumit, and Wenlan Qian. January 2016. "Access to Home Equity and Consumption:
	Evidence from a Policy Experiment" 

Data: Due to confidentially agreements with the data providers, the data used in this 
	analysis is not available for public distribution. We will store the data at NUS 
	and any researcher can come and access the data on a stand-alone computer for 
	replication and validation purposes.  
	
Data files for the anlaysis: 
	HousingConsumption_final.dta: the sample data of Singaporeans living in HDB market 
 
	
Key regressors:
	(log)totspend: (natural logarithm of) total monthly spending on debit and credit cards at the individual level
	(log)debitspend: (natural logarithm of) total monthly spending on debit cards at the individual level
	(log)totccspend: (natural logarithm of) total monthly spending on credit cards at the individual level
	(log)totspend_durable: (natural lograithm) of total monthly card spending on (small) durable goods (apparel, 
		electronics or computers,office and home furnishings)
	(log)totspend_nondurable: (natural lograithm) of total monthly card spending on non-durable items 
	
Other Key variables:
	cinmask: unique identifier for each consumer

	premarried: treatment dummy, = 1 if the consumer is married (as of the pre-policy period), 0 otherwise
	premarried_aft: = 1 for consumers in the treatment group in months after 2010:08, and 0 otherwise
	premarried_pre: = 1 for consumers in the treatment group between 2010:05 and 2010:08, and 0 otherwise

	female: = 1 for female, 0 otherwise
	chinese:  = 1 for ethnically Chinese, 0 otherwise
	highedu: = 1 if the consumer's highest education is college degree or above
	
	preinc: the average income in the pre-policy period 
	preaveprice: the average quarterly public housing price (at the postal sector level) between 2000 and 2012
	preage: age (in years) as of 2010:08
	
	lowpreccroom: = 1 if the consumer's (percentage) difference between the granted credit limit and the average 
		outstanding credit card debt between 2010:04 and 2010:08 is in the bottom tercile of the sample distribution),0 otherwise
	hiprebal: = 1 if the consumer’s average checking account balance between 2010:04 and 2010:08 is in the top 
		tercile of the sample distribution, 0 otherwise. 
	hipreinc: = 1 if the consumer’s average monthly income between 2010:05-2010:08 is in the top tercile of 
		the sample distribution, 0 otherwise. 
	lowprefunds: =1 if the consumer's combined liquid funds (checking account balance + remaining credit) between 
		2010:04 and 2010:08 is in the bottom tercile of the sample distribution, 0 otherwise
	hipricegrowth: = 1 if the treated consumers live in a postal sector that experienced an above median average 
		growth rate in the HDB resale price during 2007-2009, 0 otherwise
	
*/

global outputdir "`where you save the results'"
global workdir "`where the test data are placed'"

***************************************
******	Table 1
***************************************  
** SUMMARY STATISTICS

use "$workdir\HousingConsumption_final", clear
	bysort cinmask : egen totspendmave=mean(totspend)
	bysort cinmask : egen totccspendmave=mean(totccspend)
	bysort cinmask : egen totdbspendmave=mean(debitspend)
	**
	sort cinmask yrmo 
	quietly by  cinmask    :  gen dupck = cond(_N==1,0,_n)
	drop if dupck>1
	**

	log using "$outputdir\Table1.log", replace
		**
		ttest totspendmave, by(premarried)
		ttest totccspendmave, by(premarried)
		ttest totdbspendmave, by(premarried)
		ttest preinc, by(premarried)
		ttest prebal, by(premarried)
		ttest preaveprice, by(premarried)
		ttest preage, by(premarried)
		ttest female, by(premarried)
		ttest premarried, by(premarried)
		ttest chinese, by(premarried)
		log close

	
***************************************
******	Table 2
***************************************  
** Average Treatment Effect	
use "$workdir\HousingConsumption_final", clear

	xi:areg logtotspend premarried_aft  premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table2a", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending") replace
	xi:areg logtotccspend premarried_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table2a", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log credit card spending") 
	xi:areg logdebitspend premarried_aft  premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table2a", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending")

	xi:areg logtotspend_durable premarried_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table2b", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*)  ctitle("Durable") replace
	xi:areg logtotspend_nondurable premarried_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table2b", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*)  ctitle("Non-Durable") 

***************************************
******	Table 3
*************************************** 
** Credit Constraints 

	** close distance to credit limit
	gen premarried_lowccroom_aft=premarried_aft* lowpreccroom
	
	xi:areg logtotspend premarried_aft  premarried_lowccroom_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table3", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending")  replace
	xi:areg logtotccspend premarried_aft  premarried_lowccroom_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table3", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 
	xi:areg logdebitspend premarried_aft  premarried_lowccroom_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table3", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending")


***************************************
******	Table 4
***************************************
** The Role of Precautionary Savings   

	** high checking account balance
	gen premarried_highbal_aft=premarried_aft*hiprebal

	xi:areg logtotspend premarried_aft  premarried_highbal_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table4a", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending") replace
	xi:areg logtotccspend premarried_aft  premarried_highbal_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table4a", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending")  
	xi:areg logdebitspend premarried_aft  premarried_highbal_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table4a", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 

			
	** alternative measure of precautionary savings
	gen highrisk = highedu==0
	gen premarried_highriskhighinc_aft = premarried_aft * highrisk * highpreinc
				
	xi:areg logtotspend premarried_aft  premarried_highriskhighinc_aft  premarried_pre  i.yrmo, abs(cinmask) cluster(cinmask) 
		outreg2 using "$outputdir\Table4b", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending") replace
	xi:areg logtotccspend premarried_aft  premarried_highriskhighinc_aft  premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table4b", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 
	xi:areg logdebitspend premarried_aft  premarried_highriskhighinc_aft  premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table4b", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending")  
			
			
	* low total funds
	gen premarried_lowfunds_aft=premarried_aft * lowprefunds

	xi:areg logtotspend premarried_aft  premarried_lowfunds_aft premarried_pre  i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table4c", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending") replace
	xi:areg logtotccspend premarried_aft  premarried_lowfunds_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table4c", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 
	xi:areg logdebitspend premarried_aft  premarried_lowfunds_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table4c", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 
 
***************************************
******	Table 5
***************************************	
** By Regional House Price Growth	
			
	gen premarried_pricegrowth_aft=premarried_aft* hipricegrowth

	xi:areg logtotspend premarried_aft  premarried_pricegrowth_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table5", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log total card spending") replace
	xi:areg logtotccspend premarried_aft  premarried_pricegrowth_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table5", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 
	xi:areg logdebitspend premarried_aft  premarried_pricegrowth_aft premarried_pre i.yrmo , abs(cinmask) cluster(cinmask)
		outreg2 using "$outputdir\Table5", word bdec(3) tdec(2) stats(coef tstat) drop(_Iy*) ctitle("Log debit card spending") 

***************************************
******	Figure 1
***************************************	
** Dynamics of Consumption Response			

	tabulate yrmo if yrmo>=201005, gen(aft201008_)
	for var aft201008_* : replace X=0 if X==.
	for var aft201008_* : gen premarried_X=X*premarried
	
	**total spend
	*---------------------------------------**---------------------------------------*
	xi:areg logtotspend premarried_aft201008_* i.yrmo , abs(cinmask) cluster(cinmask)
		log using "$outputdir\Figure1.log", replace
			**
			lincom premarried_aft201008_1
			lincom premarried_aft201008_1+premarried_aft201008_2
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8+premarried_aft201008_9
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8+premarried_aft201008_9+premarried_aft201008_10
		log close
			
	*---------------------------------------**---------------------------------------*
	**total CC spend
	*---------------------------------------**---------------------------------------*
	xi:areg logtotccspend premarried_aft201008_* i.yrmo , abs(cinmask) cluster(cinmask)

		log using "$outputdir\Figure1.log", append
			**
			lincom premarried_aft201008_1
			lincom premarried_aft201008_1+premarried_aft201008_2
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8+premarried_aft201008_9
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8+premarried_aft201008_9+premarried_aft201008_10
		log close
			
	*---------------------------------------**---------------------------------------*
	**total DB spend
	*---------------------------------------**---------------------------------------*
	xi:areg logdebitspend premarried_aft201008_* i.yrmo , abs(cinmask) cluster(cinmask)

		log using "$outputdir\Figure1.log", append
			**
			lincom premarried_aft201008_1
			lincom premarried_aft201008_1+premarried_aft201008_2
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8+premarried_aft201008_9
			lincom premarried_aft201008_1+premarried_aft201008_2+premarried_aft201008_3+premarried_aft201008_4+premarried_aft201008_5+premarried_aft201008_6+premarried_aft201008_7+premarried_aft201008_8+premarried_aft201008_9+premarried_aft201008_10
		log close
			
			