* Table_1

do Define_Globals

*****************************************************************
* Table 1 - Summary Statistics
*****************************************************************
*General
use listing_final, clear 
bys prime_categ: count
bys prime_categ: count if funded == 1

*Listing Characteristics
tabstat amountrequested ///
	auction_open_for_duration ///  
	amountdelinquent currentdelinquencies delinquencieslast7years /// 
	publicrecordslast12months publicrecordslast10years /// 
	inquirieslast6months ///
	bankcardutilization currentcreditlines revolvingcreditbalance totalcreditlines, /// 
	statistics(mean sd p10 p90) column(statistics) 


*Loan Outcomes	
tabstat funded, stat(mean)
tabstat borrowerrate if funded == 1, statistics(mean sd p10 p90) column(statistics)

tabstat all_payments_made_18 last_payment_made_18 num_late_payments_18 default_18, stat(mean) col(stat)
tabstat num_late_payments_18 , statistics(mean sd p10 p90) column(statistics)
