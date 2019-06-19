#delim ;
clear ;
set mem 3g ;
set more off ;

**************************************************************************************
Purpose: Read in raw DB1B data
************************************************************************************** ;

cd "..\Data";

* Coupon Detail  ;

insheet using "Origin_and_Destination_Survey_DB1BCoupon_2003_1.csv", comma names clear ; 
save "DOT DB1B Data Coupon_2003_1.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BCoupon_2003_1.csv"; 
insheet using "Origin_and_Destination_Survey_DB1BCoupon_2003_3.csv", comma names clear ; 
save "DOT DB1B Data Coupon_2003_3.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BCoupon_2003_3.csv"; 
insheet using "Origin_and_Destination_Survey_DB1BCoupon_2003_4.csv", comma names clear ; 
save "DOT DB1B Data Coupon_2003_4.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BCoupon_2003_4.csv"; 
*** etc. ;

*Market Detail  ;

insheet using "Origin_and_Destination_Survey_DB1BMarket_2003_1.csv", comma names clear ; 
save "DOT DB1B Data Market_2003_1.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BMarket_2003_1.csv"; 
insheet using "Origin_and_Destination_Survey_DB1BMarket_2003_3.csv", comma names clear ; 
save "DOT DB1B Data Market_2003_3.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BMarket_2003_3.csv"; 
insheet using "Origin_and_Destination_Survey_DB1BMarket_2003_4.csv", comma names clear ; 
save "DOT DB1B Data Market_2003_4.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BMarket_2003_4.csv"; 
insheet using "Origin_and_Destination_Survey_DB1BMarket_2004_1.csv", comma names clear ; 
save "DOT DB1B Data Market_2004_1.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BMarket_2004_1.csv"; 
*** etc. ;

*Ticket Detail ;


insheet using "Origin_and_Destination_Survey_DB1BTicket_2003_1.csv", comma names clear ; 
save "DOT DB1B Data Ticket_2003_1.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BTicket_2003_1.csv"; 
insheet using "Origin_and_Destination_Survey_DB1BTicket_2003_3.csv", comma names clear ; 
save "DOT DB1B Data Ticket_2003_3.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BTicket_2003_3.csv"; 
insheet using "Origin_and_Destination_Survey_DB1BTicket_2003_4.csv", comma names clear ; 
save "DOT DB1B Data Ticket_2003_4.dta", replace ;
erase "Origin_and_Destination_Survey_DB1BTicket_2003_4.csv"; 
insheet using "Origin_and_Destination_Survey_DB1BTicket_2004_1.csv", comma names clear ; 
save "DOT DB1B Data Ticket_2004_1.dta", replace ;
*** etc. ;
